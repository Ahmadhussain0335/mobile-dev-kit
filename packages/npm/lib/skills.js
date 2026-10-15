// Reads the skills shipped inside this package (copied from the repository
// at pack time by scripts/copy-skills.js).
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

/** @typedef {{name: string, description: string, files: Map<string, string>}} Skill */

export const skillsRoot = path.join(path.dirname(path.dirname(fileURLToPath(import.meta.url))), 'skills');

const maxSummaryLength = 100;

/** @type {Skill[] | undefined} */
let cache;

/**
 * Every bundled skill, sorted by name.
 * @param {string} [root]
 * @returns {Skill[]}
 */
export function loadSkills(root = skillsRoot) {
  if (root === skillsRoot && cache) return cache;
  if (!fs.existsSync(root)) {
    throw new Error(`Bundled skills not found at ${root}. Run: npm run copy-skills`);
  }
  const skills = fs
    .readdirSync(root, { withFileTypes: true })
    .filter((e) => e.isDirectory() && fs.existsSync(path.join(root, e.name, 'SKILL.md')))
    .map((e) => e.name)
    .sort()
    .map((name) => {
      const files = new Map();
      for (const rel of listFiles(path.join(root, name)).sort()) {
        files.set(rel, fs.readFileSync(path.join(root, name, ...rel.split('/')), 'utf8'));
      }
      return { name, description: frontmatterDescription(files.get('SKILL.md') ?? ''), files };
    });
  if (root === skillsRoot) cache = skills;
  return skills;
}

/**
 * First sentence or clause of a description, at most 100 characters.
 * @param {string} description
 */
export function summary(description) {
  let text = description;
  for (const separator of ['. ', ': ']) {
    const end = text.indexOf(separator);
    if (end !== -1) text = text.slice(0, end);
  }
  if (text.length > maxSummaryLength) {
    const cut = text.lastIndexOf(' ', maxSummaryLength - 3);
    text = `${text.slice(0, cut === -1 ? maxSummaryLength - 3 : cut)}...`;
  }
  return text;
}

/** @param {string} skillText */
function frontmatterDescription(skillText) {
  const match = /^description:\s*(.+)$/m.exec(skillText);
  if (!match) return '';
  const raw = match[1].trim();
  if (raw.startsWith('"')) {
    try {
      return JSON.parse(raw);
    } catch {
      return raw.slice(1, -1);
    }
  }
  return raw.replace(/^'(.*)'$/, '$1');
}

/** @param {string} dir */
function listFiles(dir, prefix = '') {
  /** @type {string[]} */
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.name.startsWith('.')) continue;
    const rel = prefix ? `${prefix}/${entry.name}` : entry.name;
    if (entry.isDirectory()) out.push(...listFiles(path.join(dir, entry.name), rel));
    else if (entry.isFile()) out.push(rel);
  }
  return out;
}
