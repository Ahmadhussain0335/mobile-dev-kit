// Copies the repository's skills/ folder into this package before packing
// or testing. The copy is git-ignored; skills/ at the repository root stays
// the single source of truth.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const packageRoot = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const source = path.resolve(packageRoot, '..', '..', 'skills');
const destination = path.join(packageRoot, 'skills');

if (!fs.existsSync(source)) {
  if (fs.existsSync(destination)) {
    console.log('Repository skills/ not found; keeping the existing copy.');
    process.exit(0);
  }
  console.error(`Skills folder not found: ${source}`);
  process.exit(1);
}

// Only the generated copy inside this package is replaced.
fs.rmSync(destination, { recursive: true, force: true });

let count = 0;
for (const entry of fs.readdirSync(source, { withFileTypes: true })) {
  if (!entry.isDirectory()) continue;
  if (!fs.existsSync(path.join(source, entry.name, 'SKILL.md'))) continue;
  copyTree(path.join(source, entry.name), path.join(destination, entry.name));
  count++;
}
console.log(`Copied ${count} skills into ${path.relative(process.cwd(), destination) || '.'}`);

function copyTree(from, to) {
  fs.mkdirSync(to, { recursive: true });
  for (const entry of fs.readdirSync(from, { withFileTypes: true })) {
    if (entry.name.startsWith('.')) continue;
    const src = path.join(from, entry.name);
    const dst = path.join(to, entry.name);
    if (entry.isDirectory()) {
      copyTree(src, dst);
    } else if (entry.isFile()) {
      // Normalize line endings so a Windows checkout packs the same bytes.
      fs.writeFileSync(dst, fs.readFileSync(src, 'utf8').replace(/\r\n/g, '\n'));
    }
  }
}
