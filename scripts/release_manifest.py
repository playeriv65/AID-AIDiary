"""Writes latest.json, the release manifest apps check for updates
(docs/UPDATES.md), for the packages in a folder.

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
MAX_NOTES = 40


def git(*args):
    return subprocess.run(['git', *args], check=True, capture_output=True,
                          text=True).stdout


def notes(commit, previous):
    """Commit subjects since the last release, or the latest ones."""
    span = [f'{previous}..{commit}'] if previous and subprocess.run(
        ['git', 'merge-base', '--is-ancestor', previous, commit]).returncode == 0 \
        else [commit, f'-{MAX_NOTES}']
    return [line for line in git('log', '--no-merges', '--format=%s', *span)
            .splitlines() if line][:MAX_NOTES]


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
    json.dump({
        'version': version,
        'build': args.build,
        'commit': args.commit,
        'published': datetime.now(timezone.utc).isoformat(timespec='seconds'),
        'notes': notes(args.commit, args.previous),
        'files': files,
    }, sys.stdout, ensure_ascii=False, indent=2)
    sys.stdout.write('\n')


if __name__ == '__main__':
    main()
