"""Publish the rolling Nightly release. Run with GH_REPO and GH_TOKEN."""

import argparse
import json
import os
import re
import subprocess
from datetime import datetime, timedelta, timezone
from pathlib import Path
from tempfile import TemporaryDirectory

from release_manifest import fingerprint, prepare

TAG = "nightly"
LATEST = "latest.json"
ARCHIVE = re.compile(r"latest-(?:([0-9]+-[0-9]+)-)?[0-9]+\.json")
STAGED = re.compile(r"aid-manifest-[0-9]+-[0-9]+\.json")
PACKAGE = re.compile(r"aid-build-([0-9]+-[0-9]+)-[a-z.-]+")
RETENTION = timedelta(days=7)


def gh(*args):
    return subprocess.check_output(["gh", *args])


class Nightly:
    def __init__(self, repo, commit):
        self.repo = repo
        self.root = f"repos/{repo}"
        releases = self.pages(f"{self.root}/releases")
        self.release = next((r for r in releases if r["tag_name"] == TAG), None)
        if self.release is None:
            self.release = json.loads(
                gh(
                    "api",
                    "-X",
                    "POST",
                    f"{self.root}/releases",
                    "-f",
                    f"tag_name={TAG}",
                    "-f",
                    f"target_commitish={commit}",
                    "-F",
                    "draft=true",
                    "-F",
                    "prerelease=true",
                )
            )

    @staticmethod
    def pages(url):
        pages = json.loads(gh("api", "--paginate", "--slurp", f"{url}?per_page=100"))
        return [item for page in pages for item in page]

    def assets(self):
        return {
            asset["name"]: asset
            for asset in self.pages(f"{self.root}/releases/{self.release['id']}/assets")
        }

    def asset_url(self, asset):
        return f"{self.root}/releases/assets/{asset['id']}"

    def read(self, asset):
        return json.loads(
            gh(
                "api",
                self.asset_url(asset),
                "-H",
                "Accept: application/octet-stream",
            )
        )

    def upload(self, files, *, clobber=False):
        gh(
            "release",
            "upload",
            TAG,
            *(str(file) for file in files),
            *(["--clobber"] if clobber else []),
        )

    def rename(self, asset, name):
        gh("api", "-X", "PATCH", self.asset_url(asset), "-f", f"name={name}")

    def delete(self, asset):
        gh("api", "-X", "DELETE", self.asset_url(asset))

    def finish(self, commit, build, packages):
        links = "\n".join(
            f"- [{alias}](https://github.com/{self.repo}/releases/download/{TAG}/{file['name']})"
            for alias, file in packages.items()
        )
        date = datetime.now(timezone.utc).date()
        notes = (
            f"Built from {commit}, build {build}. Android packages are signed "
            f"with the release key and update installed apps.\n\n{links}"
        )
        ref = f"{self.root}/git/refs/tags/{TAG}"
        if not self.release["draft"]:
            gh("api", "-X", "PATCH", ref, "-f", f"sha={commit}", "-F", "force=true")
        gh(
            "release",
            "edit",
            TAG,
            "--title",
            f"Nightly {date}",
            "--notes",
            notes,
            "--target",
            commit,
            "--draft=false",
        )


def current_manifest(release):
    assets = release.assets()
    if LATEST in assets:
        return assets[LATEST]
    # A cancelled run may have moved the old pointer before installing the new one.
    archives = [asset for name, asset in assets.items() if ARCHIVE.fullmatch(name)]
    if archives:
        prior = max(archives, key=lambda asset: (asset["updated_at"], asset["id"]))
        release.rename(prior, LATEST)
        return prior
    return None


def verify_assets(release, files):
    assets = release.assets()
    for file in files:
        asset = assets.get(file["name"])
        if (
            asset is None
            or asset["state"] != "uploaded"
            or asset["size"] != file["size"]
            or asset["digest"] != f"sha256:{file['sha256']}"
        ):
            raise ValueError(f"Release asset failed verification: {file['name']}")
    return assets


def prune(release, archive_name, publication, cutoff):
    assets = release.assets()
    retained = {publication}
    for name, asset in assets.items():
        archive = ARCHIVE.fullmatch(name)
        if archive and (
            name == archive_name
            or datetime.fromisoformat(asset["updated_at"]) >= cutoff
        ):
            retained.add(archive[1])
    for name, asset in assets.items():
        if (
            name == archive_name
            or datetime.fromisoformat(asset["updated_at"]) >= cutoff
        ):
            continue
        package = PACKAGE.fullmatch(name)
        if (
            ARCHIVE.fullmatch(name)
            or STAGED.fullmatch(name)
            or (package and package[1] not in retained)
        ):
            release.delete(asset)


def publish(release, dist, stage, build, commit, publication):
    active = current_manifest(release)
    previous = release.read(active) if active else {}
    if previous.get("build", 0) >= build:
        print(f"Skipping build {build}; Nightly already serves {previous['build']}")
        return

    manifest, packages = prepare(
        dist, stage, build, commit, previous.get("commit", ""), publication
    )
    candidate = stage / f"aid-manifest-{publication}.json"
    candidate.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    files = [*packages.values(), fingerprint(candidate)]
    release.upload([stage / file["name"] for file in files])
    assets = verify_assets(release, files)

    archive_name = None
    if active:
        prior_package = next(iter(previous["files"].values()))
        prior_publication = PACKAGE.fullmatch(prior_package["name"])
        identity = f"{prior_publication[1]}-" if prior_publication else ""
        archive_name = f"latest-{identity}{active['id']}.json"
    try:
        if active:
            release.rename(active, archive_name)
        release.rename(assets[candidate.name], LATEST)
    except subprocess.CalledProcessError:
        current_manifest(release)
        raise
    promoted = release.assets().get(LATEST)
    if promoted is None or promoted["id"] != assets[candidate.name]["id"]:
        raise RuntimeError("Could not verify the promoted Nightly manifest")

    release.finish(commit, build, packages)
    # Keep fixed manual download links. Leave the old names intact on the
    # first cutover so clients holding the last fixed-name manifest can finish.
    cutoff = datetime.now(timezone.utc) - RETENTION
    legacy = any(
        (archive := ARCHIVE.fullmatch(name))
        and not archive[1]
        and (
            name == archive_name
            or datetime.fromisoformat(asset["updated_at"]) >= cutoff
        )
        for name, asset in release.assets().items()
    )
    if not legacy:
        release.upload([dist / name for name in packages], clobber=True)
    prune(release, archive_name, publication, cutoff)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dist", type=Path, required=True)
    parser.add_argument("--build", type=int, required=True)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--publication", required=True)
    args = parser.parse_args()
    release = Nightly(os.environ["GH_REPO"], args.commit)
    with TemporaryDirectory(prefix="aid-nightly-") as work:
        publish(
            release, args.dist, Path(work), args.build, args.commit, args.publication
        )


if __name__ == "__main__":
    main()
