"""Build the update manifest and stage the packages it references."""

import hashlib
import json
import re
import shutil
import subprocess
from datetime import datetime, timezone
from pathlib import Path

# Manifest keys and the files the nightly publishes for them.
FILES = {
    "android": "aid-diary.apk",
    "android-dev": "aid-diary-dev.apk",
    "windows": "aid-diary-windows-setup.exe",
    "linux": "aid-diary-linux.tar.gz",
}
# Published for manual download, outside the manifest: the portable Windows
# ZIP and the command lines.
DOWNLOADS = ("aid-diary-windows.zip", "aid-windows.exe", "aid-linux")
# Without a release to compare with, the newest entries of CHANGES.json.
LATEST_CHANGES = 5


def changes_at(commit):
    """CHANGES.json as it was at [commit]; empty when it was not there."""
    shown = subprocess.run(
        ["git", "show", f"{commit}:CHANGES.json"],
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    return json.loads(shown.stdout) if shown.returncode == 0 else []


def changes(commit, previous):
    """The CHANGES.json entries added since the last release."""
    entries = changes_at(commit)
    if (
        not previous
        or subprocess.run(
            ["git", "merge-base", "--is-ancestor", previous, commit]
        ).returncode
    ):
        return entries[-LATEST_CHANGES:]
    released = {entry["id"] for entry in changes_at(previous)}
    return [entry for entry in entries if entry["id"] not in released]


def notes_by_language(entries):
    """Each language's lines; an entry without one says it in English."""
    languages = {key for entry in entries for key in entry if key != "id"}
    return {
        language: [entry.get(language, entry["en"]) for entry in entries]
        for language in sorted(languages)
    }


def prepare(dist, output, build, commit, previous, publication):
    """Stage immutable packages and return their manifest and fingerprints."""
    if not re.fullmatch(r"[0-9]+-[0-9]+", publication):
        raise ValueError("Publication must contain the run ID and attempt")
    pubspec = Path("pubspec.yaml").read_text(encoding="utf-8")
    version = re.search(r"^version:\s*([^+\s]+)", pubspec, re.M).group(1)
    packages = {}
    for name in (*FILES.values(), *DOWNLOADS):
        asset = f"aid-build-{publication}-{name}"
        path = output / asset
        shutil.copyfile(dist / name, path)
        packages[name] = fingerprint(path)
    entries = changes(commit, previous)
    manifest = {
        "version": version,
        "build": build,
        "commit": commit,
        "published": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        # English lines for apps from before notesByLanguage.
        "notes": [entry["en"] for entry in entries],
        "notesByLanguage": notes_by_language(entries),
        "files": {key: packages[name] for key, name in FILES.items()},
    }
    return manifest, packages


def fingerprint(path):
    size = path.stat().st_size
    if size <= 0:
        raise ValueError(f"Empty release file: {path.name}")
    with path.open("rb") as stream:
        digest = hashlib.file_digest(stream, "sha256").hexdigest()
    return {"name": path.name, "size": size, "sha256": digest}
