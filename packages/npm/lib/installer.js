// Installs, removes and inspects skills on disk. Every write and delete stays
// inside <skills folder>/<skill name>/. Behaviour and the marker format match
// the Dart CLI, so either tool can manage folders the other installed.
import fs from 'node:fs';
import path from 'node:path';

import { resolveTarget } from './targets.js';

export const markerFileName = '.mobile-dev-kit.json';
const markerOwners = new Set(['mobile_dev_kit', 'mobile-dev-kit']);
const writtenBy = 'mobile-dev-kit';

/** @typedef {'created'|'updated'|'unchanged'|'forced'|'conflict'|'notADirectory'|'removed'|'keptUserFiles'|'notInstalled'} ActionKind */
/** @typedef {{skill: string, directory: string, kind: ActionKind}} SkillAction */
/** @typedef {{path: string, tools: string[]}} SkillsLocation */
/** @typedef {import('./skills.js').Skill} Skill */

export class Installer {
  /**
   * @param {{projectRoot: string, home: string, skills: Skill[], version: string}} options
   */
  constructor({ projectRoot, home, skills, version }) {
    this.projectRoot = projectRoot;
    this.home = home;
    this.skills = skills;
    this.version = version;
  }

  /**
   * Unique skills folders for the given targets.
   * @param {import('./targets.js').Target[]} targets
   * @param {{global: boolean}} options
   * @returns {SkillsLocation[]}
   */
  locations(targets, { global }) {
    /** @type {Map<string, string[]>} */
    const byPath = new Map();
    for (const target of targets) {
      const dir = resolveTarget(target, { global, projectRoot: this.projectRoot, home: this.home });
      if (!byPath.has(dir)) byPath.set(dir, []);
      byPath.get(dir)?.push(target.name);
    }
    return [...byPath].map(([p, tools]) => ({ path: p, tools }));
  }

  /**
   * @param {SkillsLocation[]} locations
   * @param {{selected?: string[], force?: boolean, dryRun?: boolean}} [options]
   * @returns {SkillAction[]}
   */
  install(locations, { selected = [], force = false, dryRun = false } = {}) {
    const actions = [];
    for (const location of locations) {
      for (const skill of this.#select(selected)) {
        const dir = path.join(location.path, skill.name);
        actions.push({ skill: skill.name, directory: dir, kind: this.#installOne(skill, dir, force, dryRun) });
      }
    }
    return actions;
  }

  /**
   * @param {SkillsLocation[]} locations
   * @param {{selected?: string[], dryRun?: boolean}} [options]
   * @returns {SkillAction[]}
   */
  uninstall(locations, { selected = [], dryRun = false } = {}) {
    const actions = [];
    for (const location of locations) {
      for (const skill of this.#select(selected)) {
        const dir = path.join(location.path, skill.name);
        actions.push({ skill: skill.name, directory: dir, kind: this.#uninstallOne(dir, dryRun) });
      }
    }
    return actions;
  }

  /**
   * Bundled skill names present in a location, managed or not.
   * @param {SkillsLocation} location
   * @returns {{skill: string, directory: string, installedVersion: string | null}[]}
   */
  inspect(location) {
    const found = [];
    for (const skill of this.skills) {
      const dir = path.join(location.path, skill.name);
      if (entryType(dir) === 'missing') continue;
      found.push({ skill: skill.name, directory: dir, installedVersion: readMarker(dir)?.version ?? null });
    }
    return found;
  }

  /** @param {string[]} selected */
  #select(selected) {
    return selected.length === 0 ? this.skills : this.skills.filter((s) => selected.includes(s.name));
  }

  /**
   * @param {Skill} skill
   * @param {string} dir
   * @param {boolean} force
   * @param {boolean} dryRun
   * @returns {ActionKind}
   */
  #installOne(skill, dir, force, dryRun) {
    const type = entryType(dir);
    if (type === 'missing') {
      if (!dryRun) this.#write(skill, dir, null);
      return 'created';
    }
    if (type !== 'directory') return 'notADirectory';
    const marker = readMarker(dir);
    if (!marker) {
      if (!force) return 'conflict';
      if (!dryRun) this.#write(skill, dir, null);
      return 'forced';
    }
    if (marker.version === this.version && matches(skill, dir)) return 'unchanged';
    if (!dryRun) this.#write(skill, dir, marker);
    return 'updated';
  }

  /**
   * @param {string} dir
   * @param {boolean} dryRun
   * @returns {ActionKind}
   */
  #uninstallOne(dir, dryRun) {
    const type = entryType(dir);
    if (type === 'missing') return 'notInstalled';
    if (type !== 'directory') return 'notADirectory';
    const marker = readMarker(dir);
    if (!marker) return 'conflict';

    const listed = new Set([...marker.files, markerFileName]);
    const others = listTree(dir).filter((rel) => !listed.has(rel));
    if (dryRun) return others.length > 0 ? 'keptUserFiles' : 'removed';

    // Resolve every path first so an unsafe entry aborts before anything is deleted.
    const paths = [...listed].map((rel) => inside(dir, rel));
    for (const p of paths) {
      if (entryType(p) === 'file') fs.unlinkSync(p);
    }
    deleteEmptyDirectories(dir, false);
    return fs.existsSync(dir) ? 'keptUserFiles' : 'removed';
  }

  /**
   * @param {Skill} skill
   * @param {string} dir
   * @param {{version: string, files: string[]} | null} previous
   */
  #write(skill, dir, previous) {
    if (previous) {
      const stale = previous.files.filter((f) => !skill.files.has(f)).map((f) => inside(dir, f));
      for (const p of stale) {
        if (entryType(p) === 'file') fs.unlinkSync(p);
      }
      deleteEmptyDirectories(dir, true);
    }
    for (const [rel, content] of skill.files) {
      const file = inside(dir, rel);
      fs.mkdirSync(path.dirname(file), { recursive: true });
      fs.writeFileSync(file, content);
    }
    const marker = {
      installedBy: writtenBy,
      version: this.version,
      skill: skill.name,
      files: [...skill.files.keys()].sort(),
    };
    fs.writeFileSync(path.join(dir, markerFileName), `${JSON.stringify(marker, null, 2)}\n`);
  }
}

/** @param {string} p @returns {'missing'|'file'|'directory'|'link'|'other'} */
function entryType(p) {
  let stat;
  try {
    stat = fs.lstatSync(p);
  } catch {
    return 'missing';
  }
  if (stat.isSymbolicLink()) return 'link';
  if (stat.isDirectory()) return 'directory';
  if (stat.isFile()) return 'file';
  return 'other';
}

/** @param {string} dir */
function readMarker(dir) {
  const file = path.join(dir, markerFileName);
  if (entryType(file) !== 'file') return null;
  try {
    const json = JSON.parse(fs.readFileSync(file, 'utf8'));
    if (!json || !markerOwners.has(json.installedBy) || typeof json.version !== 'string' || !Array.isArray(json.files)) {
      return null;
    }
    return { version: json.version, files: json.files.filter((/** @type {unknown} */ f) => typeof f === 'string') };
  } catch {
    return null;
  }
}

/** @param {Skill} skill @param {string} dir */
function matches(skill, dir) {
  for (const [rel, content] of skill.files) {
    const file = inside(dir, rel);
    if (entryType(file) !== 'file' || fs.readFileSync(file, 'utf8') !== content) return false;
  }
  return true;
}

/**
 * Joins a relative path onto dir, refusing anything outside it, lexically or
 * through a symbolic link in an intermediate folder.
 * @param {string} dir
 * @param {string} rel
 */
export function inside(dir, rel) {
  const target = path.normalize(path.join(dir, ...rel.split('/')));
  const relative = path.relative(dir, target);
  if (relative === '' || relative.startsWith('..') || path.isAbsolute(relative)) {
    throw new Error(`Refusing to touch ${target}: outside ${dir}`);
  }
  for (let parent = path.dirname(target); parent !== dir && path.dirname(parent) !== parent; parent = path.dirname(parent)) {
    if (entryType(parent) === 'link') {
      throw new Error(`Refusing to touch ${target}: ${parent} is a symbolic link`);
    }
  }
  return target;
}

/** Files below dir as forward-slash relative paths, without following links. @param {string} dir */
function listTree(dir, prefix = '') {
  /** @type {string[]} */
  const out = [];
  for (const entry of fs.readdirSync(path.join(dir, ...prefix.split('/').filter(Boolean)), { withFileTypes: true })) {
    const rel = prefix ? `${prefix}/${entry.name}` : entry.name;
    if (entry.isDirectory()) out.push(...listTree(dir, rel));
    else out.push(rel);
  }
  return out;
}

/** Removes empty folders below dir, deepest first, then dir itself unless keepRoot. */
function deleteEmptyDirectories(/** @type {string} */ dir, /** @type {boolean} */ keepRoot) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) deleteEmptyDirectories(path.join(dir, entry.name), false);
  }
  if (!keepRoot && fs.readdirSync(dir).length === 0) fs.rmdirSync(dir);
}
