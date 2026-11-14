// ignore_for_file: avoid_print

/// Plans and runs a Patrol test with a video recording, in any Flutter project.
///
/// Commands:
///   plan   resolve the run and print it, or print the one question to ask
///   run    plan, then run Patrol and record the video
///   list   print the Patrol projects and their tests
///   init   write a starter .patrol-runner.json at the repository root
///
/// Exit codes: 0 ready or passed, 1 blocked or failed, 2 a question to ask,
/// 64 bad arguments.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'patrol_config.dart';
import 'patrol_input_validation.dart';
import 'patrol_plan.dart';
import 'patrol_platform.dart';

Future<void> main(List<String> arguments) async {
  final RunnerCommand command;
  try {
    command = RunnerCommand.parse(arguments);
  } on ArgumentError catch (error) {
    stderr.writeln('[patrol] ${error.message}');
    stderr.writeln('[patrol] Run with --help for usage.');
    exit(64);
  }

  try {
    exit(await command.execute());
  } on StateError catch (error) {
    print('PLAN_STATUS=blocked');
    print('REASON=${error.message}');
    exit(1);
  }
}

final class RunnerCommand {
  const RunnerCommand({required this.name, required this.request});

  final String name;
  final PlanRequest request;

  static const Set<String> _names = <String>{'plan', 'run', 'list', 'init'};

  static String get scriptPath => File(Platform.script.toFilePath()).path;

  static RunnerCommand parse(List<String> arguments) {
    if (arguments.isEmpty ||
        arguments.first == '--help' ||
        arguments.first == '-h') {
      printUsage();
      exit(0);
    }
    final String name = arguments.first;
    if (!_names.contains(name)) {
      throw ArgumentError(
        'Unknown command "$name". Use plan, run, list or init.',
      );
    }

    String? project;
    String? testDir;
    String? test;
    String? device;
    PatrolPlatform? platform;
    String? flutterCommand;
    String? outputDir;
    int timeoutSec = 1800;
    bool noRecord = false;
    final List<String> patrolArgs = <String>[];

    for (int index = 1; index < arguments.length; index++) {
      final String argument = arguments[index];
      String value() {
        if (index + 1 >= arguments.length) {
          throw ArgumentError('Missing value for $argument');
        }
        index++;
        return arguments[index];
      }

      switch (argument) {
        case '--project':
          project = PatrolInputValidation.requirePath(
            value(),
            label: 'project',
          );
        case '--test-dir':
          testDir = PatrolInputValidation.requireTestDir(value());
        case '--test':
          test = value();
        case '--device':
          device = PatrolInputValidation.requireDeviceId(value());
        case '--platform':
          platform = PatrolPlatform.parse(value());
        case '--flutter-command':
          flutterCommand = value();
        case '--output-dir':
          outputDir = File(
            PatrolInputValidation.requirePath(
              value(),
              label: 'output directory',
            ),
          ).absolute.path;
        case '--timeout-sec':
          timeoutSec = PatrolInputValidation.requireTimeoutSec(
            int.parse(value()),
          );
        case '--no-record':
          noRecord = true;
        case '--':
          patrolArgs.addAll(arguments.sublist(index + 1));
          index = arguments.length;
        case '--help':
        case '-h':
          printUsage();
          exit(0);
        default:
          throw ArgumentError('Unknown argument: $argument');
      }
    }

    return RunnerCommand(
      name: name,
      request: PlanRequest(
        project: project,
        testDir: testDir,
        test: test,
        device: device,
        platform: platform,
        noRecord: noRecord,
        outputDir: outputDir,
        flutterCommand: flutterCommand,
        timeoutSec: timeoutSec,
        patrolArgs: patrolArgs,
      ),
    );
  }

  static void printUsage() {
    print('''
Plan and run a Patrol test with a video recording.

Usage:
  dart run run_patrol_test.dart <plan|run|list|init> [options] [-- <patrol test args>]

Commands:
  plan    Resolve the run. Prints PLAN_STATUS=ready|ask|blocked and key=value lines.
  run     Plan, then run Patrol and record. Stops with the plan output unless ready.
  list    Print the Patrol projects and their tests.
  init    Write a starter ${RunnerConfig.fileName} at the repository root.

Options:
  --project <dir>          Flutter app folder with the Patrol tests
  --test-dir <dir>         Patrol test folder (default: config, then
                           patrol.test_directory in pubspec.yaml, then patrol_test)
  --test <marker|path>     test marker or path inside the test folder
  --device <id|name>       adb id, iOS simulator name or UDID, or chrome
  --platform <name>        android, ios or web
  --flutter-command <cmd>  Flutter command (default: config, then "fvm flutter"
                           for FVM projects, then "flutter")
  --output-dir <dir>       video folder (default: config, then
                           <project>/<test-dir>/recordings)
  --timeout-sec <n>        watcher timeout in seconds (default: 1800)
  --no-record              run without a video
  -- <args>                pass the remaining arguments to "patrol test"

Recorder choice (printed as RECORDER):
  android        patrol-cli (--record-video) on Patrol CLI ${PatrolVersions.recordVideo}+, else watcher-adb
  ios simulator  patrol-cli (--record-video) on Patrol CLI ${PatrolVersions.recordVideo}+, else watcher-simctl
  ios device     none (cannot be recorded)
  web            playwright (--web-video on), needs Patrol CLI ${PatrolVersions.web}+
''');
  }

  Future<int> execute() async {
    final String workingDir = Directory.current.path;
    switch (name) {
      case 'list':
        return _list(workingDir);
      case 'init':
        return _init(workingDir);
    }

    final Plan plan = await Planner(workingDir: workingDir).resolve(request);
    plan.printReport(scriptPath: scriptPath);
    if (name == 'plan' || plan.status != PlanStatus.ready) {
      return plan.exitCode;
    }
    return PatrolExecution(plan: plan).run();
  }

  int _list(String workingDir) {
    final RunnerConfig config = RunnerConfig.load(startDir: workingDir);
    final String? requested = request.project;
    final List<String> projects = requested == null
        ? PatrolProjects.find(config)
        : <String>[
            RunnerConfig.canonical(
              requested.startsWith('/') ? requested : '$workingDir/$requested',
            ),
          ];
    print('ROOT=${config.rootDir}');
    print('CONFIG=${config.path ?? '(none)'}');
    for (final String project in projects) {
      final String testDir =
          request.testDir ??
          PatrolProjects.testDir(projectDir: project, config: config);
      print('PROJECT=$project');
      for (final PatrolTestFile test in PatrolProjects.tests(
        projectDir: project,
        testDir: testDir,
      )) {
        print('TEST=${test.relativePath} :: ${test.marker}');
      }
    }
    return projects.isEmpty ? 1 : 0;
  }

  int _init(String workingDir) {
    final RunnerConfig existing = RunnerConfig.load(startDir: workingDir);
    final String target = '${existing.rootDir}/${RunnerConfig.fileName}';
    if (File(target).existsSync()) {
      print('CONFIG=$target');
      print('INIT=exists');
      return 0;
    }

    final List<String> projects = PatrolProjects.find(existing);
    final Map<String, Object?> projectEntries = <String, Object?>{
      for (final String project in projects)
        PatrolProjects.relative(
          root: existing.rootDir,
          path: project,
        ): <String, Object?>{
          'testDir': PatrolProjects.testDir(
            projectDir: project,
            config: existing,
          ),
          'patrolArgs': <String, List<String>>{
            'all': <String>[],
            'android': <String>[],
            'ios': <String>[],
            'web': <String>[],
          },
        },
    };
    final Map<String, Object?> config = <String, Object?>{
      'defaultProject': projects.length == 1
          ? PatrolProjects.relative(
              root: existing.rootDir,
              path: projects.first,
            )
          : null,
      'platform': null,
      'outputDir': null,
      'flutterCommand': null,
      'projects': projectEntries,
    };
    File(target).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(config)}\n',
    );
    print('CONFIG=$target');
    print('INIT=created');
    print('PROJECTS=${projects.length}');
    return 0;
  }
}

final class PatrolExecution {
  PatrolExecution({required this.plan});

  final Plan plan;

  late final String _logFile =
      '${Directory.systemTemp.path}/patrol_${plan.test.baseName}.log';
  late final String _watcherLog =
      '${plan.outputDir}/screenrecord_${plan.test.baseName}.log';
  late final String _stopFile =
      '${plan.outputDir}/.patrol_${plan.test.baseName}.stop';
  late final String _completionMarker =
      '${plan.outputDir}/.patrol_${plan.test.baseName}.recording.complete';

  Future<int> run() async {
    final DateTime startedAt = DateTime.now();
    final RecorderType recorder = plan.recorder;
    for (final String path in <String>[
      _logFile,
      _stopFile,
      _completionMarker,
    ]) {
      _deleteIfExists(path);
    }
    if (recorder != RecorderType.none) {
      Directory(plan.outputDir).createSync(recursive: true);
    }

    final WebVideoSettings? webVideo = recorder == RecorderType.playwright
        ? WebVideoSettings.from(
            patrolArgs: plan.patrolArgs,
            marker: plan.test.baseName,
            projectDir: plan.projectDir,
          )
        : null;
    final List<String> recorderArgs = switch (recorder) {
      RecorderType.patrolCli => <String>[
        if (!plan.patrolArgs.contains('--record-video')) ...<String>[
          '--record-video',
          '--video-output-dir',
          plan.outputDir,
        ],
      ],
      RecorderType.playwright => webVideo?.patrolArgs ?? <String>[],
      _ => <String>[],
    };

    Process? watcher;
    IOSink? watcherSink;
    if (recorder.usesWatcher) {
      print('[patrol] Step 1/3: start the ${recorder.id} watcher');
      final ({Process process, IOSink sink}) started = await _startWatcher(
        recorder: recorder,
      );
      watcher = started.process;
      watcherSink = started.sink;
    } else {
      print(
        '[patrol] Step 1/3: recorder ${recorder.id} (${plan.recorderReason})',
      );
    }

    print('[patrol] Step 2/3: run patrol test');
    final int exitCode = await _runPatrol(extraArgs: recorderArgs);

    print('[patrol] Step 3/3: collect the video');
    if (watcher != null) {
      File(_stopFile).writeAsStringSync('stop');
      await _awaitWatcher(watcher);
      await watcherSink?.close();
    }
    await webVideo?.collect(recordingsDir: plan.outputDir);

    final List<String> recordings = _recordingsSince(startedAt);
    final String? report = _reportPath();

    final bool keepLogs =
        exitCode != 0 || (recorder != RecorderType.none && recordings.isEmpty);
    _deleteIfExists(_stopFile);
    _deleteIfExists(_completionMarker);
    if (!keepLogs) {
      _deleteIfExists(_watcherLog);
      _deleteIfExists(_logFile);
      webVideo?.deleteOwnedResults();
    }

    print('');
    print('RESULT=${exitCode == 0 ? 'passed' : 'failed'}');
    print('EXIT_CODE=$exitCode');
    print('RECORDER=${recorder.id}');
    for (final String recording in recordings) {
      print('RECORDING=$recording');
    }
    if (recorder != RecorderType.none && recordings.isEmpty) {
      print(
        'RECORDING_MISSING=${recorder.usesWatcher ? _watcherLog : 'see the patrol output above'}',
      );
    }
    if (report != null) {
      print('REPORT=$report');
    }
    if (keepLogs) {
      print('PATROL_LOG=$_logFile');
      final String? resultsDir = webVideo?.resultsDir;
      if (resultsDir != null) {
        print('WEB_RESULTS_DIR=$resultsDir');
      }
    }
    return exitCode == 0 ? 0 : 1;
  }

  Future<({Process process, IOSink sink})> _startWatcher({
    required RecorderType recorder,
  }) async {
    _deleteIfExists(_watcherLog);
    final IOSink sink = File(_watcherLog).openWrite();
    final String watcherScript =
        '${File(RunnerCommand.scriptPath).parent.path}/patrol_screenrecord.dart';
    final String? deviceId = plan.deviceId;
    if (deviceId == null) {
      throw StateError('The watcher needs a device id.');
    }
    final String watcherPlatform = recorder == RecorderType.watcherSimctl
        ? 'ios'
        : 'android';

    final Process process = await Process.start(
      Platform.resolvedExecutable,
      <String>[
        'run',
        watcherScript,
        '--platform',
        watcherPlatform,
        '--device',
        deviceId,
        '--marker',
        plan.test.baseName,
        '--output-dir',
        plan.outputDir,
        '--timeout-sec',
        '${plan.request.timeoutSec}',
        '--log-file',
        _logFile,
        '--stop-file',
        _stopFile,
        // Patrol CLI before 4.7.0 does not stream iOS simulator logs, so the
        // 🧪 start line may never appear.
        if (recorder == RecorderType.watcherSimctl) '--start-immediately',
      ],
    );
    process.stdout.listen(sink.add);
    process.stderr.listen(sink.add);
    print('[patrol] Watcher log: $_watcherLog');
    return (process: process, sink: sink);
  }

  Future<void> _awaitWatcher(Process watcher) async {
    try {
      await watcher.exitCode.timeout(const Duration(seconds: 45));
    } on TimeoutException {
      print(
        '[patrol] Warning: the watcher did not finish in 45s. Stopping it.',
      );
      watcher.kill();
    }
  }

  Future<int> _runPatrol({required List<String> extraArgs}) async {
    final IOSink logSink = File(_logFile).openWrite();
    final String? deviceId = plan.deviceId;
    final Map<String, String> environment = <String, String>{
      if (plan.platform != PatrolPlatform.ios &&
          plan.platform != PatrolPlatform.web)
        'GRADLE_USER_HOME': _gradleHome(),
    };

    final Process process = await Process.start(
      'patrol',
      <String>[
        'test',
        '--target',
        plan.target,
        '--flutter-command',
        plan.flutterCommand,
        if (deviceId != null) ...<String>['--device', deviceId],
        // Echoes the 🧪 and "Test summary" lines the watcher waits for.
        '--show-flutter-logs',
        ...extraArgs,
        ...plan.patrolArgs,
      ],
      workingDirectory: plan.projectDir,
      environment: environment,
    );

    final StreamSubscription<List<int>> stdoutSub = process.stdout.listen((
      List<int> data,
    ) {
      stdout.add(data);
      logSink.add(data);
    });
    final StreamSubscription<List<int>> stderrSub = process.stderr.listen((
      List<int> data,
    ) {
      stderr.add(data);
      logSink.add(data);
    });

    final int exitCode = await process.exitCode;
    await stdoutSub.cancel();
    await stderrSub.cancel();
    await logSink.close();
    return exitCode;
  }

  // Agent sandboxes often point GRADLE_USER_HOME at an empty cache, which
  // turns every run into a cold 5 to 15 minute Gradle build.
  String _gradleHome() {
    final String? existing = Platform.environment['GRADLE_USER_HOME'];
    if (existing != null &&
        existing.isNotEmpty &&
        !existing.toLowerCase().contains('sandbox')) {
      return existing;
    }
    final String? home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home != null && home.isNotEmpty) {
      return '$home/.gradle';
    }
    return existing ?? '.gradle';
  }

  List<String> _recordingsSince(DateTime startedAt) {
    final Directory directory = Directory(plan.outputDir);
    if (!directory.existsSync()) {
      return <String>[];
    }
    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (File file) =>
              file.path.endsWith('.mp4') || file.path.endsWith('.webm'),
        )
        .where((File file) => file.lastModifiedSync().isAfter(startedAt))
        .map((File file) => file.path)
        .toList()
      ..sort();
  }

  String? _reportPath() {
    final File log = File(_logFile);
    if (!log.existsSync()) {
      return null;
    }
    final RegExpMatch? match = RegExp(
      r'📊[^\n]*?Report:\s*(\S+)',
    ).firstMatch(log.readAsStringSync());
    return match?.group(1);
  }

  void _deleteIfExists(String path) {
    final File file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}

final class WebVideoSettings {
  WebVideoSettings._({
    required this.resultsDir,
    required this.ownsResultsDir,
    required this.patrolArgs,
    required this.marker,
    required this.startedAt,
  });

  final String resultsDir;
  final bool ownsResultsDir;
  final List<String> patrolArgs;
  final String marker;
  final DateTime startedAt;

  static WebVideoSettings from({
    required List<String> patrolArgs,
    required String marker,
    required String projectDir,
  }) {
    final DateTime startedAt = DateTime.now();
    final String? userResultsDir = _optionValue(
      arguments: patrolArgs,
      name: '--web-results-dir',
    );
    final bool userSetVideo =
        _optionValue(arguments: patrolArgs, name: '--web-video') != null;
    final String resultsDir;
    if (userResultsDir == null) {
      resultsDir =
          '${Directory.systemTemp.path}/patrol_web_${marker}_${startedAt.millisecondsSinceEpoch}';
    } else if (userResultsDir.startsWith('/')) {
      resultsDir = userResultsDir;
    } else {
      resultsDir = '$projectDir/$userResultsDir';
    }

    return WebVideoSettings._(
      resultsDir: resultsDir,
      ownsResultsDir: userResultsDir == null,
      marker: marker,
      startedAt: startedAt,
      patrolArgs: <String>[
        if (!userSetVideo) ...<String>['--web-video', 'on'],
        if (userResultsDir == null) ...<String>[
          '--web-results-dir',
          resultsDir,
        ],
      ],
    );
  }

  /// Copies the newest Playwright video into [recordingsDir], as MP4 when
  /// ffmpeg is available, else as the original WebM.
  Future<void> collect({required String recordingsDir}) async {
    final Directory results = Directory(resultsDir);
    if (!results.existsSync()) {
      return;
    }
    final List<File> videos =
        results
            .listSync(recursive: true)
            .whereType<File>()
            .where((File file) => file.path.endsWith('.webm'))
            .where((File file) => file.lastModifiedSync().isAfter(startedAt))
            .toList()
          ..sort(
            (File a, File b) =>
                b.lastModifiedSync().compareTo(a.lastModifiedSync()),
          );
    if (videos.isEmpty) {
      return;
    }

    final String basePath = '$recordingsDir/${marker}_${_timestamp()}';
    final File source = videos.first;
    if (await Tools.isOnPath('ffmpeg')) {
      final ProcessResult result = await Process.run('ffmpeg', <String>[
        '-y',
        '-v',
        'warning',
        '-i',
        source.path,
        '-an',
        // libx264 with yuv420p needs even frame sizes.
        '-vf',
        'scale=trunc(iw/2)*2:trunc(ih/2)*2',
        '-c:v',
        'libx264',
        '-preset',
        'veryfast',
        '-pix_fmt',
        'yuv420p',
        '-movflags',
        '+faststart',
        '$basePath.mp4',
      ]);
      if (result.exitCode == 0) {
        return;
      }
      print('[patrol] ffmpeg could not convert the WebM. Keeping it as is.');
    }
    await source.copy('$basePath.webm');
  }

  void deleteOwnedResults() {
    final Directory results = Directory(resultsDir);
    if (ownsResultsDir && results.existsSync()) {
      results.deleteSync(recursive: true);
    }
  }

  static String? _optionValue({
    required List<String> arguments,
    required String name,
  }) {
    for (int index = 0; index < arguments.length; index++) {
      final String argument = arguments[index];
      if (argument == name && index + 1 < arguments.length) {
        return arguments[index + 1];
      }
      if (argument.startsWith('$name=')) {
        return argument.substring(name.length + 1);
      }
    }
    return null;
  }

  static String _timestamp() {
    final DateTime now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${now.year}${two(now.month)}${two(now.day)}_'
        '${two(now.hour)}${two(now.minute)}${two(now.second)}';
  }
}
