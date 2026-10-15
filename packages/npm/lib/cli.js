// The mobile-dev-kit command line. Commands, flags, output and exit codes
// mirror the Dart CLI (packages/dart).
import path from 'node:path';

import { Installer } from './installer.js';
import { loadSkills, summary } from './skills.js';
import { UsageError, allTargetsName, defaultTargetNames, selectTargets, targets } from './targets.js';
import { packageVersion } from './version.js';

export const usageExitCode = 64;
const executable = 'mobile-dev-kit';

/**
 * @typedef {{write: (text: string) => unknown}} Sink
 * @typedef {{out?: Sink, err?: Sink, env?: NodeJS.ProcessEnv, cwd?: string, platform?: string}} CliOptions
 */

/**
 * Runs the command line and returns the exit code.
 * @param {string[]} args
 * @param {CliOptions} [options]
 */
export async function runCli(args, options = {}) {
  const out = lineWriter(options.out ?? process.stdout);
  const err = lineWriter(options.err ?? process.stderr);
  const ctx = {
    out,
    err,
    env: options.env ?? process.env,
    cwd: options.cwd ?? process.cwd(),
    platform: options.platform ?? process.platform,
  };
  try {
    return run(args, ctx);
  } catch (error) {
    if (error instanceof UsageError) {
      err(error.message);
      err('');
      err(`Run "${executable} help" for usage.`);
      return usageExitCode;
    }
    err(`Error: ${error instanceof Error ? error.message : String(error)}`);
    return 1;
  }
}

/**
 * Resolves the home directory: USERPROFILE first on Windows, HOME first
 * elsewhere, each falling back to the other.
 * @param {NodeJS.ProcessEnv} env
 * @param {string} platform
 */
export function resolveHome(env, platform = process.platform) {
  const order = platform === 'win32' ? ['USERPROFILE', 'HOME'] : ['HOME', 'USERPROFILE'];
  for (const key of order) {
    const value = env[key];
    if (value) return value;
  }
  throw new Error('Cannot find the home directory: set HOME or USERPROFILE.');
}

const commandHelp = {
  list: 'List the bundled skills.',
  targets: 'Show each supported tool with its project and global skills folder.',
  install: 'Install skills into one or more tools.',
  uninstall: 'Remove skills that this tool installed. Other folders are never touched.',
  doctor: 'Show where skills are installed and whether they are outdated.',
};

/** @param {string[]} args @param {Context} ctx */
function run(args, ctx) {
  const [command, ...rest] = args;
  if (command === undefined || command === 'help' || command === '--help' || command === '-h') {
    ctx.out(mainUsage());
    return 0;
  }
  if (command === '--version') {
    ctx.out(packageVersion);
    return 0;
  }
  switch (command) {
    case 'list':
      return list(parse(rest, {}), ctx);
    case 'targets':
      return showTargets(parse(rest, {}), ctx);
    case 'install':
      return install(parse(rest, skillOptions(true)), ctx);
    case 'uninstall':
      return uninstall(parse(rest, skillOptions(true)), ctx);
    case 'doctor':
      return doctor(parse(rest, { dir: { short: 'd', value: true } }), ctx);
    default:
      throw new UsageError(`Could not find a command named "${command}".`);
  }
}

/** @typedef {{out: (line: string) => void, err: (line: string) => void, env: NodeJS.ProcessEnv, cwd: string, platform: string}} Context */
/** @typedef {{short?: string, value?: boolean, multi?: boolean, allowed?: string[]}} OptionSpec */
/** @typedef {{flags: Set<string>, values: Map<string, string[]>, help: boolean}} Parsed */

/** @param {boolean} withForce @returns {Record<string, OptionSpec>} */
function skillOptions(withForce) {
  return {
    tool: { short: 't', value: true, multi: true, allowed: [...targets.map((t) => t.name), allTargetsName] },
    skill: { short: 's', value: true, multi: true },
    global: { short: 'g' },
    'dry-run': { short: 'n' },
    dir: { short: 'd', value: true },
    ...(withForce ? { force: { short: 'f' } } : {}),
  };
}

/**
 * Minimal option parser: --name, --name=value, --name value, -x, -x value.
 * @param {string[]} args
 * @param {Record<string, OptionSpec>} specs
 * @returns {Parsed}
 */
function parse(args, specs) {
  /** @type {Parsed} */
  const parsed = { flags: new Set(), values: new Map(), help: false };
  const byShort = new Map(Object.entries(specs).filter(([, s]) => s.short).map(([n, s]) => [s.short, n]));
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--help' || arg === '-h') {
      parsed.help = true;
      continue;
    }
    let name;
    let inline;
    if (arg.startsWith('--')) {
      const eq = arg.indexOf('=');
      name = eq === -1 ? arg.slice(2) : arg.slice(2, eq);
      inline = eq === -1 ? undefined : arg.slice(eq + 1);
    } else if (arg.startsWith('-') && arg.length === 2) {
      name = byShort.get(arg.slice(1));
      if (!name) throw new UsageError(`Could not find an option or flag "${arg}".`);
    } else {
      throw new UsageError(`Unexpected argument: ${arg}`);
    }
    const spec = specs[name];
    if (!spec) throw new UsageError(`Could not find an option named "--${name}".`);
    if (!spec.value) {
      if (inline !== undefined) throw new UsageError(`Flag "--${name}" does not take a value.`);
      parsed.flags.add(name);
      continue;
    }
    const value = inline ?? args[++i];
    if (value === undefined) throw new UsageError(`Missing argument for "--${name}".`);
    if (spec.allowed && !spec.allowed.includes(value)) {
      throw new UsageError(`"${value}" is not an allowed value for option "--${name}". Allowed: ${spec.allowed.join(', ')}`);
    }
    const list = parsed.values.get(name) ?? [];
    if (!spec.multi) list.length = 0;
    list.push(value);
    parsed.values.set(name, list);
  }
  return parsed;
}

/** @param {Parsed} parsed @param {Context} ctx */
function list(parsed, ctx) {
  if (parsed.help) return help('list', ctx);
  const skills = loadSkills();
  const width = Math.max(...skills.map((s) => s.name.length));
  for (const skill of skills) ctx.out(`${skill.name.padEnd(width)}  ${summary(skill.description)}`);
  return 0;
}

/** @param {Parsed} parsed @param {Context} ctx */
function showTargets(parsed, ctx) {
  if (parsed.help) return help('targets', ctx);
  const rows = [['TOOL', 'PROJECT', 'GLOBAL', 'NAME'], ...targets.map((t) => [t.name, t.projectPath, `~/${t.globalPath}`, t.label])];
  const widths = [0, 1, 2].map((c) => Math.max(...rows.map((r) => r[c].length)));
  for (const row of rows) ctx.out([0, 1, 2].map((c) => row[c].padEnd(widths[c])).concat(row[3]).join('  '));
  ctx.out('');
  ctx.out(
    `Default (no --tool): ${defaultTargetNames.join(', ')}. --tool ${allTargetsName} selects every tool; shared folders are written once.`,
  );
  return 0;
}

/** @param {Parsed} parsed @param {Context} ctx */
function makeInstaller(parsed, ctx) {
  const skills = loadSkills();
  const known = new Set(skills.map((s) => s.name));
  for (const name of parsed.values.get('skill') ?? []) {
    if (!known.has(name)) {
      throw new UsageError(`"${name}" is not an allowed value for option "--skill". Allowed: ${[...known].join(', ')}`);
    }
  }
  const global = parsed.flags.has('global');
  const dirOption = parsed.values.get('dir')?.[0];
  const dir = dirOption === undefined ? undefined : path.resolve(ctx.cwd, dirOption);
  const installer = new Installer({
    projectRoot: global ? ctx.cwd : (dir ?? ctx.cwd),
    home: global ? (dir ?? resolveHome(ctx.env, ctx.platform)) : '',
    skills,
    version: packageVersion,
  });
  const locations = installer.locations(selectTargets(parsed.values.get('tool') ?? []), { global });
  return { installer, locations };
}

/** @param {Parsed} parsed @param {Context} ctx */
function install(parsed, ctx) {
  if (parsed.help) return help('install', ctx);
  const dryRun = parsed.flags.has('dry-run');
  const { installer, locations } = makeInstaller(parsed, ctx);
  const actions = installer.install(locations, {
    selected: parsed.values.get('skill') ?? [],
    force: parsed.flags.has('force'),
    dryRun,
  });
  report(actions, locations, dryRun, ctx);
  if (actions.some((a) => a.kind === 'conflict')) {
    ctx.err(
      'Some folders already exist and were not installed by mobile-dev-kit. They were left unchanged. Re-run with --force to overwrite them.',
    );
  }
  if (actions.some((a) => a.kind === 'notADirectory')) {
    ctx.err('Some skill paths are symbolic links or files and were left unchanged. Remove them first if you want this tool to manage them.');
  }
  return actions.some((a) => a.kind === 'conflict' || a.kind === 'notADirectory') ? 1 : 0;
}

/** @param {Parsed} parsed @param {Context} ctx */
function uninstall(parsed, ctx) {
  if (parsed.help) return help('uninstall', ctx);
  const dryRun = parsed.flags.has('dry-run');
  const { installer, locations } = makeInstaller(parsed, ctx);
  const actions = installer.uninstall(locations, { selected: parsed.values.get('skill') ?? [], dryRun });
  report(actions, locations, dryRun, ctx);
  if (actions.some((a) => a.kind === 'conflict')) {
    ctx.err('Some folders were not installed by mobile-dev-kit and were left untouched.');
  }
  if (actions.some((a) => a.kind === 'keptUserFiles')) {
    ctx.err('Some folders contained files not installed by mobile-dev-kit. Those files and their folders were kept.');
  }
  return 0;
}

/** @param {Parsed} parsed @param {Context} ctx */
function doctor(parsed, ctx) {
  if (parsed.help) return help('doctor', ctx);
  const skills = loadSkills();
  const dirOption = parsed.values.get('dir')?.[0];
  const installer = new Installer({
    projectRoot: dirOption === undefined ? ctx.cwd : path.resolve(ctx.cwd, dirOption),
    home: resolveHome(ctx.env, ctx.platform),
    skills,
    version: packageVersion,
  });
  ctx.out(`mobile-dev-kit ${packageVersion}`);
  let anything = false;
  let outdated = 0;
  for (const global of [false, true]) {
    for (const location of installer.locations([...targets], { global })) {
      const found = installer.inspect(location);
      if (found.length === 0) continue;
      anything = true;
      const managed = found.filter((s) => s.installedVersion !== null).length;
      ctx.out('');
      ctx.out(
        `${global ? 'global ' : 'project'} ${location.path} (${location.tools.join(', ')}): ${managed} of ${skills.length} installed`,
      );
      for (const skill of found) {
        let status;
        if (skill.installedVersion === null) {
          status = 'not managed by mobile-dev-kit';
        } else if (skill.installedVersion !== packageVersion) {
          status = `outdated (${skill.installedVersion})`;
          outdated++;
        } else {
          status = `ok (${skill.installedVersion})`;
        }
        ctx.out(`  ${skill.skill.padEnd(24)} ${status}`);
      }
    }
  }
  if (!anything) {
    ctx.out('');
    ctx.out(`No skills found. Run: ${executable} install`);
  } else if (outdated > 0) {
    ctx.out('');
    ctx.out(`${outdated} outdated. Run the same install command again to update.`);
  }
  return 0;
}

const labels = {
  created: ['created', 'would create'],
  updated: ['updated', 'would update'],
  unchanged: ['unchanged', 'unchanged'],
  forced: ['overwritten', 'would overwrite'],
  conflict: ['skipped (exists)', 'would skip (exists)'],
  notADirectory: ['skipped (link/file)', 'would skip (link)'],
  removed: ['removed', 'would remove'],
  keptUserFiles: ['removed, folder kept', 'would remove files'],
  notInstalled: ['not installed', 'not installed'],
};

/**
 * @param {import('./installer.js').SkillAction[]} actions
 * @param {import('./installer.js').SkillsLocation[]} locations
 * @param {boolean} dryRun
 * @param {Context} ctx
 */
function report(actions, locations, dryRun, ctx) {
  const prefix = dryRun ? '[dry-run] ' : '';
  const label = (/** @type {import('./installer.js').ActionKind} */ kind) => labels[kind][dryRun ? 1 : 0];
  for (const location of locations) {
    ctx.out(`${prefix}${location.path} (${location.tools.join(', ')})`);
    for (const action of actions.filter((a) => path.dirname(a.directory) === location.path)) {
      ctx.out(`  ${label(action.kind).padEnd(20)} ${action.skill}`);
    }
  }
  /** @type {Map<import('./installer.js').ActionKind, number>} */
  const counts = new Map();
  for (const a of actions) counts.set(a.kind, (counts.get(a.kind) ?? 0) + 1);
  ctx.out(`${prefix}${[...counts].map(([kind, n]) => `${n} ${label(kind)}`).join(', ')}.`);
}

function mainUsage() {
  return [
    'Installs the mobile-dev-kit Agent Skills for Android, iOS and Flutter into AI coding tools.',
    '',
    `Usage: ${executable} <command> [arguments]`,
    '',
    'Global options:',
    '-h, --help       Print this usage information.',
    '    --version    Print the version and exit.',
    '',
    'Available commands:',
    ...Object.entries(commandHelp).map(([name, text]) => `  ${name.padEnd(10)} ${text}`),
    '',
    `Run "${executable} <command> --help" for more information about a command.`,
  ].join('\n');
}

/** @param {keyof typeof commandHelp} command @param {Context} ctx */
function help(command, ctx) {
  const lines = [commandHelp[command], '', `Usage: ${executable} ${command} [arguments]`];
  if (command === 'install' || command === 'uninstall') {
    lines.push(
      '-t, --tool=<tool>    Tool to act on. Repeat for several. Default: claude, agents.',
      `                     [${[...targets.map((t) => t.name), allTargetsName].join(', ')}]`,
      '-s, --skill=<name>   Skill to act on. Repeat for several. Default: all.',
      '-g, --global         Use the user-level folders in the home directory instead of the project.',
      '-n, --dry-run        Show what would change without writing anything.',
      '-d, --dir=<path>     Project root (default: current directory). With --global, used as the home directory instead.',
      command === 'install'
        ? '-f, --force          Overwrite skill folders that were not installed by this tool.'
        : '-f, --force          Accepted for symmetry with install. Folders without a marker are never removed.',
    );
  } else if (command === 'doctor') {
    lines.push('-d, --dir=<path>     Project root to inspect (default: current directory).');
  }
  ctx.out(lines.join('\n'));
  return 0;
}

/** @param {Sink} sink */
function lineWriter(sink) {
  return (/** @type {string} */ line) => {
    sink.write(`${line}\n`);
  };
}
