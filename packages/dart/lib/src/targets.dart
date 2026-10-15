import 'package:path/path.dart' as p;

/// An AI coding tool and the folders it loads Agent Skills from.
///
/// Paths use forward slashes and are relative to the project root
/// ([projectPath]) or to the user's home directory ([globalPath]).
/// Sources for every path are listed in `docs/SOURCES.md` in the repository.
class Target {
  /// Creates a target. Paths are relative and use forward slashes.
  const Target({
    required this.name,
    required this.label,
    required this.projectPath,
    required this.globalPath,
  });

  /// Identifier used with `--tool`, for example `claude`.
  final String name;

  /// Human-readable tool name.
  final String label;

  /// Skills folder relative to the project root.
  final String projectPath;

  /// Skills folder relative to the user's home directory.
  final String globalPath;

  /// The skills folder for this target, either inside [projectRoot] or, when
  /// [global] is true, inside [home].
  String resolve({
    required bool global,
    required String projectRoot,
    required String home,
  }) {
    final base = global ? home : projectRoot;
    final relative = global ? globalPath : projectPath;
    return p.normalize(p.join(base, p.joinAll(relative.split('/'))));
  }
}

/// Every supported tool. This table is the only place install paths are
/// defined; keep it in sync with `docs/SOURCES.md`.
const List<Target> targets = [
  Target(
    name: 'claude',
    label: 'Claude Code',
    projectPath: '.claude/skills',
    globalPath: '.claude/skills',
  ),
  Target(
    name: 'codex',
    label: 'OpenAI Codex',
    projectPath: '.agents/skills',
    globalPath: '.agents/skills',
  ),
  Target(
    name: 'gemini',
    label: 'Gemini CLI',
    projectPath: '.agents/skills',
    globalPath: '.gemini/skills',
  ),
  Target(
    name: 'copilot',
    label: 'GitHub Copilot',
    projectPath: '.github/skills',
    globalPath: '.copilot/skills',
  ),
  Target(
    name: 'cursor',
    label: 'Cursor',
    projectPath: '.cursor/skills',
    globalPath: '.cursor/skills',
  ),
  Target(
    name: 'antigravity',
    label: 'Google Antigravity',
    projectPath: '.agents/skills',
    globalPath: '.gemini/config/skills',
  ),
  Target(
    name: 'windsurf',
    label: 'Windsurf (Devin Desktop)',
    projectPath: '.windsurf/skills',
    globalPath: '.codeium/windsurf/skills',
  ),
  Target(
    name: 'agents',
    label: 'Any tool reading .agents/skills',
    projectPath: '.agents/skills',
    globalPath: '.agents/skills',
  ),
];

/// Tools used when no `--tool` is given. Together they cover every tool in
/// [targets] for project installs, because the others also read
/// `.claude/skills` or `.agents/skills`.
const List<String> defaultTargetNames = ['claude', 'agents'];

/// Pseudo tool name that selects every target.
const String allTargetsName = 'all';

/// Looks up a target by [name], or returns null if there is none.
Target? targetByName(String name) {
  for (final target in targets) {
    if (target.name == name) return target;
  }
  return null;
}

/// Expands tool names into targets: no names means [defaultTargetNames],
/// and [allTargetsName] means every target.
///
/// Throws [ArgumentError] for an unknown name.
List<Target> selectTargets(Iterable<String> names) {
  final requested = names.isEmpty ? defaultTargetNames : names.toList();
  if (requested.contains(allTargetsName)) return List.of(targets);
  return [
    for (final name in requested)
      targetByName(name) ??
          (throw ArgumentError.value(
            name,
            'tool',
            'Unknown tool. Valid tools: '
                '${[...targets.map((t) => t.name), allTargetsName].join(', ')}',
          )),
  ];
}
