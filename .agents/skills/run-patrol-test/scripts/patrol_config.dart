/// Loads `.patrol-runner.json` and finds Patrol projects and tests.
library;

import 'dart:convert';
import 'dart:io';

import 'patrol_platform.dart';

final class ProjectConfig {
  const ProjectConfig({required this.testDir, required this.patrolArgs});

  final String? testDir;
  final Map<String, List<String>> patrolArgs;

  List<String> argsFor(PatrolPlatform? platform) {
    return <String>[
      ...?patrolArgs['all'],
      if (platform != null) ...?patrolArgs[platform.name],
    ];
  }
}

final class RunnerConfig {
  const RunnerConfig({
    required this.path,
    required this.rootDir,
    required this.defaultProject,
    required this.platform,
    required this.outputDir,
    required this.flutterCommand,
    required this.projects,
  });

  static const String fileName = '.patrol-runner.json';

  final String? path;
  final String rootDir;
  final String? defaultProject;
  final PatrolPlatform? platform;
  final String? outputDir;
  final String? flutterCommand;

  /// Project settings, keyed by absolute project path.
  final Map<String, ProjectConfig> projects;

  ProjectConfig projectConfig(String projectDir) {
    return projects[projectDir] ??
        const ProjectConfig(
          testDir: null,
          patrolArgs: <String, List<String>>{},
        );
  }

  /// Finds the config file in [startDir] or a parent folder. Without one,
  /// the root is the git top level, else [startDir].
  static RunnerConfig load({required String startDir}) {
    final File? file = _find(startDir);
    if (file == null) {
      return RunnerConfig(
        path: null,
        rootDir: canonical(_gitRoot(startDir) ?? startDir),
        defaultProject: null,
        platform: null,
        outputDir: null,
        flutterCommand: null,
        projects: const <String, ProjectConfig>{},
      );
    }

    final String rootDir = canonical(file.parent.path);
    final Object? decoded;
    try {
      decoded = jsonDecode(file.readAsStringSync());
    } on FormatException catch (error) {
      throw StateError('Invalid JSON in ${file.path}: ${error.message}');
    }
    if (decoded is! Map<String, Object?>) {
      throw StateError('${file.path} must hold a JSON object.');
    }

    final Map<String, ProjectConfig> projects = <String, ProjectConfig>{};
    final Object? rawProjects = decoded['projects'];
    if (rawProjects is Map<String, Object?>) {
      for (final MapEntry<String, Object?> entry in rawProjects.entries) {
        final Object? value = entry.value;
        final Map<String, Object?> settings = value is Map<String, Object?>
            ? value
            : <String, Object?>{};
        projects[_absolute(root: rootDir, path: entry.key)] = ProjectConfig(
          testDir: _string(settings['testDir']),
          patrolArgs: _argsMap(settings['patrolArgs']),
        );
      }
    }

    final String? defaultProject = _string(decoded['defaultProject']);
    final String? outputDir = _string(decoded['outputDir']);
    final String? platform = _string(decoded['platform']);

    return RunnerConfig(
      path: file.path,
      rootDir: rootDir,
      defaultProject: defaultProject == null
          ? null
          : _absolute(root: rootDir, path: defaultProject),
      platform: platform == null ? null : PatrolPlatform.parse(platform),
      outputDir: outputDir == null
          ? null
          : _absolute(root: rootDir, path: outputDir),
      flutterCommand: _string(decoded['flutterCommand']),
      projects: projects,
    );
  }

  static File? _find(String startDir) {
    Directory directory = Directory(startDir);
    while (true) {
      final File file = File('${directory.path}/$fileName');
      if (file.existsSync()) {
        return file;
      }
      final Directory parent = directory.parent;
      if (parent.path == directory.path) {
        return null;
      }
      directory = parent;
    }
  }

  static String? _gitRoot(String startDir) {
    try {
      final ProcessResult result = Process.runSync('git', <String>[
        'rev-parse',
        '--show-toplevel',
      ], workingDirectory: startDir);
      final String output = result.stdout.toString().trim();
      return result.exitCode == 0 && output.isNotEmpty ? output : null;
    } on ProcessException {
      return null;
    }
  }

  static String? _string(Object? value) {
    return value is String && value.trim().isNotEmpty ? value.trim() : null;
  }

  static Map<String, List<String>> _argsMap(Object? value) {
    if (value is! Map<String, Object?>) {
      return <String, List<String>>{};
    }
    final Map<String, List<String>> args = <String, List<String>>{};
    for (final MapEntry<String, Object?> entry in value.entries) {
      final Object? list = entry.value;
      if (list is List<Object?>) {
        args[entry.key] = list.whereType<String>().toList();
      }
    }
    return args;
  }

  static String _absolute({required String root, required String path}) {
    final String joined = path.startsWith('/') ? path : '$root/$path';
    return canonical(joined);
  }

  /// Resolves symlinks so the same folder always gives the same key.
  static String canonical(String path) {
    final Directory directory = Directory(path);
    if (directory.existsSync()) {
      return directory.resolveSymbolicLinksSync();
    }
    return directory.absolute.uri.normalizePath().toFilePath().replaceFirst(
      RegExp(r'(?<=.)/$'),
      '',
    );
  }
}

final class PatrolTestFile {
  const PatrolTestFile({required this.relativePath});

  /// Path inside the Patrol test folder, such as `auth/login_test.dart`.
  final String relativePath;

  String get baseName =>
      relativePath.split('/').last.replaceAll('_test.dart', '');

  String get marker =>
      relativePath.replaceAll('_test.dart', '').replaceAll('/', '_');
}

abstract final class PatrolProjects {
  static const String defaultTestDir = 'patrol_test';

  static const Set<String> _skippedDirs = <String>{
    'build',
    'node_modules',
    'Pods',
    'ios',
    'android',
    'macos',
    'windows',
    'linux',
    'web',
  };

  /// Returns the test folder: the config value, else `patrol.test_directory`
  /// from pubspec.yaml, else `patrol_test`.
  static String testDir({
    required String projectDir,
    required RunnerConfig config,
  }) {
    final String? configured = config.projectConfig(projectDir).testDir;
    if (configured != null) {
      return configured;
    }
    final File pubspec = File('$projectDir/pubspec.yaml');
    if (pubspec.existsSync()) {
      final RegExpMatch? section = RegExp(
        r'^patrol:[ \t]*\n((?:[ \t]+.*\n|[ \t]*\n)*)',
        multiLine: true,
      ).firstMatch('${pubspec.readAsStringSync()}\n');
      final RegExpMatch? value = RegExp(
        r'''^[ \t]+test_directory:[ \t]*["']?([^"'\s#]+)''',
        multiLine: true,
      ).firstMatch(section?.group(1) ?? '');
      final String? directory = value?.group(1);
      if (directory != null) {
        return directory;
      }
    }
    return defaultTestDir;
  }

  static bool isPatrolProject({
    required String projectDir,
    required RunnerConfig config,
  }) {
    return File('$projectDir/pubspec.yaml').existsSync() &&
        Directory(
          '$projectDir/${testDir(projectDir: projectDir, config: config)}',
        ).existsSync();
  }

  /// Lists the projects in the config, else scans [RunnerConfig.rootDir].
  static List<String> find(RunnerConfig config) {
    if (config.projects.isNotEmpty) {
      return config.projects.keys.toList()..sort();
    }
    final List<String> found = <String>[
      if (isPatrolProject(projectDir: config.rootDir, config: config))
        config.rootDir,
    ];
    _scan(
      directory: Directory(config.rootDir),
      depth: 0,
      config: config,
      found: found,
    );
    return found..sort();
  }

  static List<PatrolTestFile> tests({
    required String projectDir,
    required String testDir,
  }) {
    final Directory directory = Directory('$projectDir/$testDir');
    if (!directory.existsSync()) {
      return <PatrolTestFile>[];
    }
    final String prefix = '${directory.path}/';
    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => file.path.endsWith('_test.dart'))
        .map(
          (File file) =>
              PatrolTestFile(relativePath: file.path.replaceFirst(prefix, '')),
        )
        .toList()
      ..sort(
        (PatrolTestFile a, PatrolTestFile b) =>
            a.relativePath.compareTo(b.relativePath),
      );
  }

  static String relative({required String root, required String path}) {
    if (path == root) {
      return '.';
    }
    return path.startsWith('$root/') ? path.substring(root.length + 1) : path;
  }

  static void _scan({
    required Directory directory,
    required int depth,
    required RunnerConfig config,
    required List<String> found,
  }) {
    if (depth > 4) {
      return;
    }
    final List<Directory> children;
    try {
      children = directory
          .listSync(followLinks: false)
          .whereType<Directory>()
          .toList();
    } on FileSystemException {
      return;
    }
    for (final Directory child in children) {
      final String name = child.uri.pathSegments
          .where((String segment) => segment.isNotEmpty)
          .last;
      if (name.startsWith('.') || _skippedDirs.contains(name)) {
        continue;
      }
      if (isPatrolProject(projectDir: child.path, config: config)) {
        found.add(child.path);
      }
      _scan(directory: child, depth: depth + 1, config: config, found: found);
    }
  }
}
