import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { test } from 'node:test';

import { loadSkills, markerFileName, packageVersion, resolveHome, targets, usageExitCode } from '../lib/index.js';
import { filesUnder, sandbox } from './helpers.js';

const skills = loadSkills();

test('default install writes every skill to .claude and .agents', async () => {
  const box = sandbox();
  const result = await box.run(['install']);
  assert.equal(result.code, 0, result.err);
  for (const folder of ['.claude/skills', '.agents/skills']) {
    for (const skill of skills) {
      const dir = box.inProject(`${folder}/${skill.name}`);
      assert.deepEqual(filesUnder(dir), [...skill.files.keys(), markerFileName].sort());
      assert.equal(fs.readFileSync(path.join(dir, 'SKILL.md'), 'utf8'), skill.files.get('SKILL.md'));
    }
  }
  assert.equal(fs.existsSync(box.inProject('.github')), false);
});

test('dry run writes nothing', async () => {
  const box = sandbox();
  const result = await box.run(['install', '--tool', 'all', '--dry-run']);
  assert.equal(result.code, 0);
  assert.match(result.out, /would create/);
  assert.deepEqual(fs.readdirSync(box.project), []);
});

test('second install reports unchanged', async () => {
  const box = sandbox();
  await box.run(['install', '-t', 'claude']);
  const result = await box.run(['install', '-t', 'claude']);
  assert.match(result.out, new RegExp(`${skills.length} unchanged`));
});

test('--tool all writes shared folders once', async () => {
  const box = sandbox();
  const result = await box.run(['install', '--tool=all']);
  assert.equal(result.code, 0, result.err);
  for (const folder of ['.claude/skills', '.agents/skills', '.github/skills', '.cursor/skills', '.windsurf/skills']) {
    assert.equal(fs.readdirSync(box.inProject(folder)).length, skills.length, folder);
  }
  assert.equal(result.out.split('\n').filter((l) => l.includes('.agents')).length, 1);
});

test('--global and --skill', async () => {
  const box = sandbox();
  const result = await box.run(['install', '-g', '-t', 'antigravity', '-s', 'mobile-mvvm']);
  assert.equal(result.code, 0, result.err);
  assert.deepEqual(fs.readdirSync(box.inHome('.gemini/config/skills')), ['mobile-mvvm']);
  assert.deepEqual(fs.readdirSync(box.project), []);
});

test('existing folders need --force and keep unrelated files', async () => {
  const box = sandbox();
  const dir = box.inProject('.claude/skills/mobile-code-review');
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(path.join(dir, 'SKILL.md'), 'mine');
  fs.writeFileSync(path.join(dir, 'notes.md'), 'keep');

  const skipped = await box.run(['install', '-t', 'claude']);
  assert.equal(skipped.code, 1);
  assert.match(skipped.err, /--force/);
  assert.equal(fs.readFileSync(path.join(dir, 'SKILL.md'), 'utf8'), 'mine');

  const forced = await box.run(['install', '-t', 'claude', '--force']);
  assert.equal(forced.code, 0, forced.err);
  assert.match(forced.out, /overwritten/);
  assert.equal(fs.readFileSync(path.join(dir, 'notes.md'), 'utf8'), 'keep');
  assert.ok(fs.existsSync(path.join(dir, markerFileName)));
});

test('update removes files dropped from the bundle', async () => {
  const box = sandbox();
  await box.run(['install', '-t', 'claude', '-s', 'mobile-mvi']);
  const dir = box.inProject('.claude/skills/mobile-mvi');
  const markerPath = path.join(dir, markerFileName);
  const marker = JSON.parse(fs.readFileSync(markerPath, 'utf8'));
  fs.writeFileSync(path.join(dir, 'references', 'old.md'), 'stale');
  fs.writeFileSync(markerPath, JSON.stringify({ ...marker, version: '0.9.0', files: [...marker.files, 'references/old.md'] }));

  const result = await box.run(['install', '-t', 'claude', '-s', 'mobile-mvi']);
  assert.match(result.out, /updated/);
  assert.equal(fs.existsSync(path.join(dir, 'references', 'old.md')), false);
  assert.equal(JSON.parse(fs.readFileSync(markerPath, 'utf8')).version, packageVersion);
});

test('symbolic links are never followed or replaced', { skip: process.platform === 'win32' }, async () => {
  const box = sandbox();
  const elsewhere = path.join(box.root, 'elsewhere');
  fs.mkdirSync(elsewhere);
  fs.writeFileSync(path.join(elsewhere, 'SKILL.md'), 'linked');
  fs.mkdirSync(box.inProject('.claude/skills'), { recursive: true });
  fs.symlinkSync(elsewhere, box.inProject('.claude/skills/mobile-swift'));

  const result = await box.run(['install', '-t', 'claude', '-s', 'mobile-swift', '--force']);
  assert.equal(result.code, 1);
  assert.match(result.out, /skipped \(link\/file\)/);
  assert.deepEqual(filesUnder(elsewhere), ['SKILL.md']);
});

test('uninstall removes what it installed and keeps user files', async () => {
  const box = sandbox();
  await box.run(['install']);
  fs.writeFileSync(box.inProject('.claude/skills/mobile-kotlin/team.md'), 'ours');
  const result = await box.run(['uninstall']);
  assert.equal(result.code, 0, result.err);
  assert.deepEqual(filesUnder(box.inProject('.agents/skills')), []);
  assert.deepEqual(filesUnder(box.inProject('.claude/skills')), ['mobile-kotlin/team.md']);
});

test('uninstall never touches folders without a marker', async () => {
  const box = sandbox();
  const dir = box.inProject('.claude/skills/mobile-security');
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(path.join(dir, 'SKILL.md'), 'mine');
  const result = await box.run(['uninstall', '-t', 'claude', '--force']);
  assert.equal(result.code, 0);
  assert.equal(fs.readFileSync(path.join(dir, 'SKILL.md'), 'utf8'), 'mine');
});

test('uninstall refuses marker paths outside the skill folder and deletes nothing', async () => {
  const box = sandbox();
  await box.run(['install', '-t', 'claude', '-s', 'mobile-java']);
  const victim = path.join(box.root, 'victim.txt');
  fs.writeFileSync(victim, 'safe');
  const dir = box.inProject('.claude/skills/mobile-java');
  const markerPath = path.join(dir, markerFileName);
  const marker = JSON.parse(fs.readFileSync(markerPath, 'utf8'));
  fs.writeFileSync(markerPath, JSON.stringify({ ...marker, files: [...marker.files, '../../../../victim.txt'] }));

  const result = await box.run(['uninstall', '-t', 'claude', '-s', 'mobile-java']);
  assert.equal(result.code, 1);
  assert.match(result.err, /outside/);
  assert.equal(fs.readFileSync(victim, 'utf8'), 'safe');
  assert.ok(fs.existsSync(path.join(dir, 'SKILL.md')));
});

test('doctor reports installs and outdated folders', async () => {
  const box = sandbox();
  assert.match((await box.run(['doctor'])).out, /No skills found/);
  await box.run(['install', '-t', 'claude']);
  const markerPath = box.inProject(`.claude/skills/mobile-mvvm/${markerFileName}`);
  const marker = JSON.parse(fs.readFileSync(markerPath, 'utf8'));
  fs.writeFileSync(markerPath, JSON.stringify({ ...marker, version: '0.1.0' }));
  const result = await box.run(['doctor']);
  assert.match(result.out, new RegExp(`${skills.length} of ${skills.length} installed`));
  assert.match(result.out, /outdated \(0\.1\.0\)/);
});

test('usage errors exit 64', async () => {
  const box = sandbox();
  for (const args of [['install', '--tool', 'vscode'], ['install', '--skill', 'nope'], ['install', 'claude'], ['frobnicate']]) {
    const result = await box.run(args);
    assert.equal(result.code, usageExitCode, args.join(' '));
  }
  assert.deepEqual(fs.readdirSync(box.project), []);
});

test('--version, --help, list and targets', async () => {
  const box = sandbox();
  assert.equal((await box.run(['--version'])).out.trim(), packageVersion);
  const help = (await box.run(['--help'])).out;
  for (const command of ['list', 'targets', 'install', 'uninstall', 'doctor']) assert.match(help, new RegExp(command));
  const list = (await box.run(['list'])).out;
  for (const skill of skills) assert.match(list, new RegExp(skill.name));
  const shown = (await box.run(['targets'])).out;
  for (const target of targets) assert.match(shown, new RegExp(target.name));
});

test('resolveHome prefers the platform variable and falls back', () => {
  assert.equal(resolveHome({ HOME: '/u', USERPROFILE: 'C:\\u' }, 'linux'), '/u');
  assert.equal(resolveHome({ HOME: '/u', USERPROFILE: 'C:\\u' }, 'win32'), 'C:\\u');
  assert.equal(resolveHome({ USERPROFILE: 'C:\\u' }, 'darwin'), 'C:\\u');
  assert.throws(() => resolveHome({}, 'linux'));
});
