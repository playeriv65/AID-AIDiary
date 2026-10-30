"""Writes latest.json, the release manifest apps check for updates
(docs/UPDATES.md), for the packages in a folder. Its notes are the
CHANGES.json entries added since the last release, in each language.

    python3 scripts/release_manifest.py --dist dist --build 261029183 \
        --commit <sha> [--previous <sha of the last release>] > dist/latest.json
"""
import argparse
import hashlib
import json
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

# Manifest keys and the files the nightly publishes for them.
FILES = {
    'android': 'aid-diary.apk',
    'android-dev': 'aid-diary-dev.apk',
    'windows': 'aid-diary-windows.zip',
    'linux': 'aid-diary-linux.tar.gz',
}
# Without a release to compare with, the newest entries of CHANGES.json.
LATEST_CHANGES = 5


def changes_at(commit):
    """CHANGES.json as it was at [commit]; empty when it was not there."""
    shown = subprocess.run(['git', 'show', f'{commit}:CHANGES.json'],
                           capture_output=True, text=True, encoding='utf-8')
    return json.loads(shown.stdout) if shown.returncode == 0 else []


def changes(commit, previous):
    """The CHANGES.json entries added since the last release."""
    entries = changes_at(commit)
    if not previous or subprocess.run(
            ['git', 'merge-base', '--is-ancestor', previous, commit]).returncode:
        return entries[-LATEST_CHANGES:]
    released = {entry['id'] for entry in changes_at(previous)}
    return [entry for entry in entries if entry['id'] not in released]


def notes_by_language(entries):
    """Each language's lines; an entry without one says it in English."""
    languages = {key for entry in entries for key in entry if key != 'id'}
    return {language: [entry.get(language, entry['en']) for entry in entries]
            for language in sorted(languages)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dist', type=Path, required=True)
    parser.add_argument('--build', type=int, required=True)
    parser.add_argument('--commit', required=True)
    parser.add_argument('--previous', default='')
    args = parser.parse_args()

    pubspec = Path('pubspec.yaml').read_text(encoding='utf-8')
    version = re.search(r'^version:\s*([^+\s]+)', pubspec, re.M).group(1)
    files = {}
    for key, name in FILES.items():
        path = args.dist / name
        data = path.read_bytes()
        files[key] = {'name': name, 'size': len(data),
                      'sha256': hashlib.sha256(data).hexdigest()}
    entries = changes(args.commit, args.previous)
    json.dump({
        'version': version,
        'build': args.build,
        'commit': args.commit,
        'published': datetime.now(timezone.utc).isoformat(timespec='seconds'),
        # English lines for apps from before notesByLanguage.
        'notes': [entry['en'] for entry in entries],
        'notesByLanguage': notes_by_language(entries),
        'files': files,
    }, sys.stdout, ensure_ascii=False, indent=2)
    sys.stdout.write('\n')


if __name__ == '__main__':
    main()
