import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';

import { loadSkills, packageVersion, targets } from '../lib/index.js';

const packageRoot = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const dartTargets = path.join(packageRoot, '..', 'dart', 'lib', 'src', 'targets.dart');

test('packageVersion matches package.json', () => {
  const pkg = JSON.parse(fs.readFileSync(path.join(packageRoot, 'package.json'), 'utf8'));
  assert.equal(packageVersion, pkg.version);
});

test('bundled skills match the repository skills folder', () => {
  const repoSkills = path.join(packageRoot, '..', '..', 'skills');
  const copied = loadSkills();
  const source = loadSkills(repoSkills);
  assert.deepEqual(
    copied.map((s) => [s.name, [...s.files]]),
    source.map((s) => [s.name, [...s.files].map(([k, v]) => [k, v.replace(/\r\n/g, '\n')])]),
  );
});

test('target table matches the Dart CLI', { skip: !fs.existsSync(dartTargets) && 'Dart package not present' }, () => {
  const source = fs.readFileSync(dartTargets, 'utf8');
  const dart = [...source.matchAll(/name: '([^']+)',\s*label: '([^']+)',\s*projectPath: '([^']+)',\s*globalPath: '([^']+)'/g)].map(
    (m) => ({ name: m[1], label: m[2], projectPath: m[3], globalPath: m[4] }),
  );
  assert.equal(dart.length, targets.length, 'could not parse every Dart target');
  assert.deepEqual(dart, targets.map((t) => ({ ...t })));
});
