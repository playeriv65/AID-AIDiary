"""Offline tests for Nightly publication and mirror cutover."""

import importlib.util
import json
import os
import subprocess
import unittest
from datetime import datetime, timezone
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from tempfile import TemporaryDirectory
from threading import Thread
from urllib.request import urlopen

from publish_nightly import current_manifest, publish
from release_manifest import DOWNLOADS, FILES, fingerprint

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "update_mirror",
    ROOT / "server/deploy/update-mirror/mirror.py",
)
mirror = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(mirror)


class Release:
    def __init__(self, directory):
        self.directory = directory
        self.metadata = {}
        self.fail_upload = False
        self.fail_promotion = False

    def assets(self):
        return {name: asset.copy() for name, asset in self.metadata.items()}

    def read(self, asset):
        return json.loads((self.directory / asset["name"]).read_bytes())

    def upload(self, paths, *, clobber=False):
        for path in paths:
            if not clobber and path.name in self.metadata:
                raise AssertionError(f"Replacing immutable asset {path.name}")
            self.add(path)
            if self.fail_upload:
                raise subprocess.CalledProcessError(1, "upload")

    def add(self, path):
        file = fingerprint(path)
        (self.directory / path.name).write_bytes(path.read_bytes())
        self.metadata[path.name] = {
            "id": max((asset["id"] for asset in self.metadata.values()), default=0) + 1,
            "name": path.name,
            "state": "uploaded",
            "size": file["size"],
            "digest": f"sha256:{file['sha256']}",
            "updated_at": datetime.now(timezone.utc).isoformat(),
        }

    def rename(self, asset, name):
        old_name = asset["name"]
        if (
            self.fail_promotion
            and name == "latest.json"
            and old_name.startswith("aid-manifest-")
        ):
            raise subprocess.CalledProcessError(1, "rename")
        if name in self.metadata:
            raise AssertionError(f"Replacing existing asset {name}")
        (self.directory / old_name).rename(self.directory / name)
        self.metadata[name] = self.metadata.pop(old_name)
        self.metadata[name].update(
            name=name, updated_at=datetime.now(timezone.utc).isoformat()
        )

    def finish(self, commit, build, packages):
        self.read(self.metadata["latest.json"])

    def delete(self, asset):
        name = asset["name"]
        (self.directory / name).unlink()
        del self.metadata[name]


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass


class PublicationTest(unittest.TestCase):
    def setUp(self):
        work = TemporaryDirectory()
        self.addCleanup(work.cleanup)
        self.root = Path(work.name)
        self.dist = self.root / "dist"
        self.dist.mkdir()
        self.source = self.root / "source"
        self.source.mkdir()
        self.target = self.root / "mirror"
        self.target.mkdir()
        self.release = Release(self.source)
        self.commit = subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            text=True,
        ).strip()

    def publish(self, build, publication):
        for name in (*FILES.values(), *DOWNLOADS):
            (self.dist / name).write_bytes(f"{build}-{name}".encode())
        stage = self.root / publication
        stage.mkdir()
        publish(self.release, self.dist, stage, build, self.commit, publication)

    def legacy(self):
        files = {}
        for key, name in FILES.items():
            path = self.dist / name
            path.write_bytes(f"legacy-{name}".encode())
            files[key] = fingerprint(path)
            self.release.add(path)
        path = self.dist / "latest.json"
        path.write_text(
            json.dumps(
                {"version": "0.1.1", "build": 1, "commit": self.commit, "files": files}
            )
        )
        self.release.add(path)

    def serve(self):
        server = ThreadingHTTPServer(
            ("127.0.0.1", 0),
            partial(QuietHandler, directory=self.source),
        )
        worker = Thread(target=server.serve_forever, daemon=True)
        worker.start()
        self.addCleanup(server.server_close)
        self.addCleanup(worker.join)
        self.addCleanup(server.shutdown)
        return f"http://127.0.0.1:{server.server_port}"

    def mirror(self, url):
        with TemporaryDirectory(dir=self.target) as work:
            mirror.publish(url, self.target, Path(work))

    def test_failed_upload_or_promotion_keeps_last_published_build(self):
        self.legacy()
        old = (self.source / "latest.json").read_bytes()
        self.release.fail_upload = True
        with self.assertRaises(subprocess.CalledProcessError):
            self.publish(2, "30-1")
        self.assertEqual((self.source / "latest.json").read_bytes(), old)
        self.release.fail_upload = False
        self.release.fail_promotion = True
        with self.assertRaises(subprocess.CalledProcessError):
            self.publish(2, "30-2")
        self.assertEqual((self.source / "latest.json").read_bytes(), old)
        self.release.fail_promotion = False
        self.publish(2, "30-3")
        self.assertEqual(
            json.loads((self.source / "latest.json").read_bytes())["build"], 2
        )
        self.assertEqual(
            (self.source / "aid-diary.apk").read_bytes(), b"legacy-aid-diary.apk"
        )

    def test_retains_downloads_across_publication_and_mirror_rollback(self):
        url = self.serve()
        self.legacy()
        self.mirror(url)
        self.publish(2, "30-1")
        self.mirror(url)
        old = (self.target / "latest.json").read_bytes()
        old_name = json.loads(old)["files"]["android"]["name"]
        os.utime(self.target / old_name, (1, 1))
        self.release.metadata[old_name]["updated_at"] = "2020-01-01T00:00:00Z"
        self.publish(3, "31-1")
        self.mirror(url)
        new_name = json.loads((self.target / "latest.json").read_bytes())["files"][
            "android"
        ]["name"]
        with urlopen(f"{url}/{old_name}") as response:
            self.assertEqual(response.read(), b"2-aid-diary.apk")
        self.assertEqual((self.target / old_name).read_bytes(), b"2-aid-diary.apk")
        self.assertEqual((self.target / new_name).read_bytes(), b"3-aid-diary.apk")
        self.assertEqual(
            (self.target / "aid-diary.apk").read_bytes(), b"legacy-aid-diary.apk"
        )

        # Select the retained manifest again to simulate an operator rollback.
        active = self.release.assets()["latest.json"]
        archive = next(
            asset
            for name, asset in self.release.assets().items()
            if name.startswith("latest-30-1-")
        )
        self.release.rename(active, f"latest-31-1-{active['id']}.json")
        self.release.rename(archive, "latest.json")
        self.mirror(url)
        self.assertEqual((self.target / "latest.json").read_bytes(), old)
        self.assertEqual((self.target / new_name).read_bytes(), b"3-aid-diary.apk")

    def test_mirror_does_not_publish_a_partial_or_corrupt_build(self):
        url = self.serve()
        self.legacy()
        self.mirror(url)
        old = (self.target / "latest.json").read_bytes()
        self.publish(2, "30-1")
        file = self.source / "aid-build-30-1-aid-diary-linux.tar.gz"
        intact = file.read_bytes()
        file.write_bytes(b"0" * len(intact))
        with self.assertRaisesRegex(ValueError, "Download failed verification"):
            self.mirror(url)
        self.assertEqual((self.target / "latest.json").read_bytes(), old)
        self.assertFalse((self.target / "aid-build-30-1-aid-diary.apk").exists())
        file.write_bytes(intact)
        self.mirror(url)
        self.assertEqual(
            json.loads((self.target / "latest.json").read_bytes())["build"], 2
        )

    def test_recovers_missing_pointer_after_interruption(self):
        self.legacy()
        active = self.release.assets()["latest.json"]
        self.release.rename(active, f"latest-{active['id']}.json")
        current_manifest(self.release)
        self.assertEqual(self.release.assets()["latest.json"]["id"], active["id"])


if __name__ == "__main__":
    unittest.main()
