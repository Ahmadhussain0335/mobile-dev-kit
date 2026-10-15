/// Installs the mobile-dev-kit Agent Skills into AI coding tools.
///
/// Most users run the `mobile_dev_kit` command. This library exposes the same
/// building blocks for scripts and tests:
///
/// * [bundledSkills]: the skills embedded in this package.
/// * [targets]: every supported tool and its skills folders.
/// * [Installer]: installs, removes and inspects skills on disk.
/// * [runCli]: runs the command line with injectable output and environment.
library;

export 'src/cli.dart' show resolveHome, runCli, usageExitCode;
export 'src/installer.dart'
    show
        ActionKind,
        InstalledSkill,
        Installer,
        SkillAction,
        SkillsLocation,
        markerFileName;
export 'src/skills.dart' show Skill, bundledSkills, skillByName;
export 'src/targets.dart'
    show
        Target,
        allTargetsName,
        defaultTargetNames,
        selectTargets,
        targetByName,
        targets;
export 'src/version.dart' show packageVersion;
