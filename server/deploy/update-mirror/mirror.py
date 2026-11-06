"""Verify and mirror the rolling Nightly release for AID Diary."""

import hashlib
import json
import os
import re
import shutil
import time
from pathlib import Path
from tempfile import TemporaryDirectory
from urllib.request import urlopen

SOURCE = "https://github.com/playeriv65/AID-AIDiary/releases/download/nightly"
TARGET = "/srv/aid-updates/www"
LATEST = "latest.json"
RETENTION_SECONDS = 7 * 24 * 60 * 60
FILES = {
    "android": "aid-diary.apk",
    "android-dev": "aid-diary-dev.apk",
    "windows": "aid-diary-windows.zip",
    "linux": "aid-diary-linux.tar.gz",
}
PACKAGE = re.compile(r"aid-build-([0-9]+-[0-9]+)-([a-z.-]+)")


def manifest(data):
    result = json.loads(data)
    if not isinstance(result, dict):
        raise ValueError("Invalid update manifest")
    build, version, files = (
        result.get("build"),
        result.get("version"),
        result.get("files"),
    )
    if (
        type(build) is not int
        or build <= 0
        or not isinstance(version, str)
        or not version.strip()
        or not isinstance(files, dict)
        or files.keys() != FILES.keys()
    ):
        raise ValueError("Invalid update manifest build, version or file set")
    publications = set()
    for key, filename in FILES.items():
        file = files[key]
        if not isinstance(file, dict):
            raise ValueError(f"Invalid package metadata for {key}")
        name, size, digest = file.get("name"), file.get("size"), file.get("sha256")
        if (
            not isinstance(name, str)
            or type(size) is not int
            or size <= 0
            or (
                not isinstance(digest, str)
                or not re.fullmatch(r"[a-fA-F0-9]{64}", digest)
            )
        ):
            raise ValueError(f"Invalid package metadata for {key}")
        if name == filename:
            publications.add(None)
        elif (match := PACKAGE.fullmatch(name)) and match[2] == filename:
            publications.add(match[1])
        else:
            raise ValueError(f"Invalid package name for {key}: {name}")
    if len(publications) != 1:
        raise ValueError("The update manifest mixes package sets")
    return result


def matches(path, file):
    if not path.is_file() or path.stat().st_size != file["size"]:
        return False
    with path.open("rb") as stream:
        return (
            hashlib.file_digest(stream, "sha256").hexdigest() == file["sha256"].lower()
        )


def fetch(source, name, path):
    with (
        urlopen(f"{source.rstrip('/')}/{name}", timeout=120) as response,
        path.open("wb") as stream,
    ):
        shutil.copyfileobj(response, stream)
        stream.flush()
        os.fsync(stream.fileno())
    path.chmod(0o644)


def publish(source, target, stage):
    candidate = stage / LATEST
    fetch(source, LATEST, candidate)
    data = candidate.read_bytes()
    incoming = manifest(data)
    latest = target / LATEST
    previous = latest.read_bytes() if latest.exists() else None
    if previous == data:
        return

    files = list(incoming["files"].values())
    for file in files:
        name = file["name"]
        destination = target / name
        if destination.exists():
            if not matches(destination, file):
                raise ValueError(f"Existing package differs from the manifest: {name}")
            continue
        fetch(source, name, stage / name)
        if not matches(stage / name, file):
            raise ValueError(f"Download failed verification: {name}")

    for file in files:
        name = file["name"]
        package = stage / name
        if package.exists():
            package.replace(target / name)
        os.utime(target / name)
    if previous is not None:
        # Retention begins when the old manifest stops being served.
        for file in manifest(previous)["files"].values():
            package = target / file["name"]
            if package.is_file():
                os.utime(package)
    candidate.replace(latest)

    cutoff = time.time() - RETENTION_SECONDS
    for package in target.iterdir():
        if (
            (match := PACKAGE.fullmatch(package.name))
            and match[2] in FILES.values()
            and package.is_file()
            and package.stat().st_mtime < cutoff
        ):
            package.unlink()
    print(f"Mirrored build {incoming['build']}")


def main():
    import fcntl

    source = os.environ.get("AID_UPDATES_SOURCE", SOURCE)
    target = Path(os.environ.get("AID_UPDATES_DIR", TARGET))
    target.mkdir(parents=True, exist_ok=True)
    lock = os.open(target / ".aid-mirror.lock", os.O_CREAT | os.O_WRONLY, 0o600)
    with os.fdopen(lock, "w") as stream:
        fcntl.flock(stream, fcntl.LOCK_EX)
        with TemporaryDirectory(prefix=".aid-mirror-", dir=target) as work:
            publish(source, target, Path(work))


if __name__ == "__main__":
    main()
