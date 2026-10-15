import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after } from 'node:test';

import { runCli } from '../lib/index.js';

/** A temporary project and home folder, removed when the test file ends. */
export function sandbox() {
  const root = fs.realpathSync(fs.mkdtempSync(path.join(os.tmpdir(), 'mobile-dev-kit-test-')));
  const project = path.join(root, 'project');
  const home = path.join(root, 'home');
  fs.mkdirSync(project);
  fs.mkdirSync(home);
  after(() => fs.rmSync(root, { recursive: true, force: true }));

  return {
    root,
    project,
    home,
    /** @param {string[]} args */
    async run(args) {
      let out = '';
      let err = '';
      const code = await runCli(args, {
        out: { write: (t) => (out += t) },
        err: { write: (t) => (err += t) },
        env: { HOME: home, USERPROFILE: home },
        cwd: project,
      });
      return { code, out, err };
    },
    /** @param {string} rel */
    inProject: (rel) => path.join(project, ...rel.split('/')),
    /** @param {string} rel */
    inHome: (rel) => path.join(home, ...rel.split('/')),
  };
}

/** Files below dir as sorted forward-slash relative paths. @param {string} dir */
export function filesUnder(dir) {
  if (!fs.existsSync(dir)) return [];
  /** @type {string[]} */
  const out = [];
  const walk = (/** @type {string} */ d, /** @type {string} */ prefix) => {
    for (const e of fs.readdirSync(d, { withFileTypes: true })) {
      const rel = prefix ? `${prefix}/${e.name}` : e.name;
      if (e.isDirectory()) walk(path.join(d, e.name), rel);
      else out.push(rel);
    }
  };
  walk(dir, '');
  return out.sort();
}
