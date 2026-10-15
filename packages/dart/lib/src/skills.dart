import 'skills_data.g.dart';

/// One Agent Skill bundled in this package.
class Skill {
  /// Creates a skill from its [name], [description] and [files].
  const Skill({
    required this.name,
    required this.description,
    required this.files,
  });

  /// Skill identifier, equal to its folder name.
  final String name;

  /// Description from the `SKILL.md` frontmatter.
  final String description;

  /// File path inside the skill folder (forward slashes) -> content.
  final Map<String, String> files;

  /// First sentence or clause of [description], at most [maxSummaryLength]
  /// characters, for one-line listings.
  String get summary {
    var text = description;
    for (final separator in ['. ', ': ']) {
      final end = text.indexOf(separator);
      if (end != -1) text = text.substring(0, end);
    }
    if (text.length > maxSummaryLength) {
      final cut = text.lastIndexOf(' ', maxSummaryLength - 3);
      text = '${text.substring(0, cut == -1 ? maxSummaryLength - 3 : cut)}...';
    }
    return text;
  }

  /// Maximum length of [summary].
  static const int maxSummaryLength = 100;
}

/// Every skill embedded in this package, sorted by name.
final List<Skill> bundledSkills = [
  for (final name in embeddedSkillFiles.keys.toList()..sort())
    Skill(
      name: name,
      description: embeddedSkillDescriptions[name] ?? '',
      files: embeddedSkillFiles[name]!,
    ),
];

/// Looks up a bundled skill by [name], or returns null if there is none.
Skill? skillByName(String name) {
  for (final skill in bundledSkills) {
    if (skill.name == name) return skill;
  }
  return null;
}
