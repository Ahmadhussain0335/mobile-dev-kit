// Every supported tool and the folders it loads Agent Skills from. Paths are
// relative to the project root or the home directory and use forward
// slashes. This table must match packages/dart/lib/src/targets.dart; a test
// checks that. Sources are listed in docs/SOURCES.md.
import path from 'node:path';

/** @typedef {{name: string, label: string, projectPath: string, globalPath: string}} Target */

/** @type {readonly Target[]} */
export const targets = Object.freeze([
  { name: 'claude', label: 'Claude Code', projectPath: '.claude/skills', globalPath: '.claude/skills' },
  { name: 'codex', label: 'OpenAI Codex', projectPath: '.agents/skills', globalPath: '.agents/skills' },
  { name: 'gemini', label: 'Gemini CLI', projectPath: '.agents/skills', globalPath: '.gemini/skills' },
  { name: 'copilot', label: 'GitHub Copilot', projectPath: '.github/skills', globalPath: '.copilot/skills' },
  { name: 'cursor', label: 'Cursor', projectPath: '.cursor/skills', globalPath: '.cursor/skills' },
  { name: 'antigravity', label: 'Google Antigravity', projectPath: '.agents/skills', globalPath: '.gemini/config/skills' },
  { name: 'windsurf', label: 'Windsurf (Devin Desktop)', projectPath: '.windsurf/skills', globalPath: '.codeium/windsurf/skills' },
  { name: 'agents', label: 'Any tool reading .agents/skills', projectPath: '.agents/skills', globalPath: '.agents/skills' },
]);

/** Tools used when no --tool is given. */
export const defaultTargetNames = Object.freeze(['claude', 'agents']);

/** Pseudo tool name that selects every target. */
export const allTargetsName = 'all';

/** @param {string} name */
export function targetByName(name) {
  return targets.find((t) => t.name === name);
}

/**
 * Expands tool names: none means the defaults, "all" means every target.
 * @param {string[]} names
 * @returns {Target[]}
 */
export function selectTargets(names) {
  const requested = names.length === 0 ? [...defaultTargetNames] : names;
  if (requested.includes(allTargetsName)) return [...targets];
  return requested.map((name) => {
    const target = targetByName(name);
    if (!target) {
      throw new UsageError(
        `Unknown tool "${name}". Valid tools: ${[...targets.map((t) => t.name), allTargetsName].join(', ')}`,
      );
    }
    return target;
  });
}

/**
 * Absolute skills folder for a target.
 * @param {Target} target
 * @param {{global: boolean, projectRoot: string, home: string}} options
 */
export function resolveTarget(target, { global, projectRoot, home }) {
  const base = global ? home : projectRoot;
  const relative = global ? target.globalPath : target.projectPath;
  return path.normalize(path.join(base, ...relative.split('/')));
}

/** Error for invalid command-line usage (exit code 64). */
export class UsageError extends Error {}
