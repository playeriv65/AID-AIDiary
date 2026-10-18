// Mechanical update of the app display name in upstream localization files.
import {readdir, readFile, writeFile} from 'node:fs/promises';
const dir = new URL('../lib/l10n/', import.meta.url);
for (const name of await readdir(dir)) {
  if (!name.endsWith('.arb')) continue;
  const path = new URL(name, dir);
  const source = await readFile(path, 'utf8');
  const next = source.replace(/("appTitle"\s*:\s*)"[^"]*"/, '$1"AID Diary"');
  if (source !== next) await writeFile(path, next);
}
