// ignore_for_file: avoid_print

/// Resolves a Patrol run into one plan, or one question when a choice is
/// ambiguous.
library;

import 'dart:io';

import 'patrol_config.dart';
import 'patrol_input_validation.dart';
import 'patrol_platform.dart';

final class PlanRequest {
  const PlanRequest({
    required this.project,
    required this.testDir,
    required this.test,
    required this.device,
    required this.platform,
    required this.noRecord,
    required this.outputDir,
    required this.flutterCommand,
    required this.timeoutSec,
    required this.patrolArgs,
  });

  final String? project;
  final String? testDir;
  final String? test;
  final String? device;
  final PatrolPlatform? platform;
  final bool noRecord;
  final String? outputDir;
  final String? flutterCommand;
  final int timeoutSec;
  final List<String> patrolArgs;
}

enum PlanStatus { ready, ask, blocked }

final class PlanOption {
  const PlanOption({required this.value, required this.label});

  final String value;
  final String label;
}

final class PlanQuestion {
  const PlanQuestion({
    required this.field,
    required this.flag,
    required this.question,
    required this.options,
    required this.hint,
  });

  final String field;
  final String flag;
  final String question;
  final List<PlanOption> options;
  final String? hint;
}

final class Plan {
  Plan.blocked({required this.reason, required this.request})
    : status = PlanStatus.blocked,
      question = null;

  Plan.ask({required PlanQuestion this.question, required this.request})
    : status = PlanStatus.ask,
      reason = null;

  Plan.ready({required this.request})
    : status = PlanStatus.ready,
      question = null,
      reason = null;

  final PlanStatus status;
  final PlanQuestion? question;
  final String? reason;
  final PlanRequest request;

  String? configPath;
  Version? cliVersion;
  Version? packageVersion;
  late final String projectDir;
  late final String testDir;
  late final PatrolTestFile test;
  late final String? deviceId;
  late final PatrolPlatform? platform;
  late final bool deviceIsVirtual;
  late final RecorderType recorder;
  late final String recorderReason;
  late final String outputDir;
  late final String flutterCommand;
  late final List<String> configPatrolArgs;
  final List<String> warnings = <String>[];

  String get target => '$testDir/${test.relativePath}';

  List<String> get patrolArgs => <String>[
    ...configPatrolArgs,
    ...request.patrolArgs,
  ];

  int get exitCode => switch (status) {
    PlanStatus.ready => 0,
    PlanStatus.ask => 2,
    PlanStatus.blocked => 1,
  };

  /// The exact `run` command that reproduces this plan.
  String runCommand({required String scriptPath}) {
    final String? id = deviceId;
    final PatrolPlatform? resolvedPlatform = platform;
    final List<String> words = <String>[
      'dart',
      'run',
      scriptPath,
      'run',
      '--project',
      projectDir,
      if (request.testDir != null) ...<String>['--test-dir', testDir],
      '--test',
      test.relativePath,
      if (id != null) ...<String>['--device', id],
      if (resolvedPlatform != null) ...<String>[
        '--platform',
        resolvedPlatform.name,
      ],
      if (request.noRecord) '--no-record',
      if (request.outputDir != null) ...<String>['--output-dir', outputDir],
      if (request.flutterCommand != null) ...<String>[
        '--flutter-command',
        flutterCommand,
      ],
      if (request.patrolArgs.isNotEmpty) ...<String>[
        '--',
        ...request.patrolArgs,
      ],
    ];
    return words.map(Tools.shellQuote).join(' ');
  }

  void printReport({required String scriptPath}) {
    print('PLAN_STATUS=${status.name}');
    final PlanQuestion? pending = question;
    final String? blockedReason = reason;
    if (blockedReason != null) {
      print('REASON=$blockedReason');
    }
    if (pending != null) {
      print('ASK=${pending.field}');
      print('ASK_FLAG=${pending.flag}');
      print('QUESTION=${pending.question}');
      final String? hint = pending.hint;
      if (hint != null) {
        print('HINT=$hint');
      }
      for (final PlanOption option in pending.options) {
        print('OPTION=${option.value} :: ${option.label}');
      }
    }
    if (status != PlanStatus.ready) {
      return;
    }
    print('CONFIG=${configPath ?? '(none)'}');
    print('PATROL_CLI=${cliVersion ?? 'unknown'}');
    print('PATROL_PACKAGE=${packageVersion ?? 'unknown'}');
    print('PROJECT=$projectDir');
    print('TARGET=$target');
    print('MARKER=${test.baseName}');
    print('DEVICE=${deviceId ?? '(Patrol picks one)'}');
    print('PLATFORM=${platform?.name ?? 'unknown'}');
    print('RECORDER=${recorder.id}');
    print('RECORDER_REASON=$recorderReason');
    print('OUTPUT_DIR=$outputDir');
    print('FLUTTER_COMMAND=$flutterCommand');
    print('PATROL_ARGS=${patrolArgs.map(Tools.shellQuote).join(' ')}');
    for (final String warning in warnings) {
      print('WARNING=$warning');
    }
    print('COMMAND=${runCommand(scriptPath: scriptPath)}');
  }
}

final class Planner {
  Planner({required this.workingDir});

  final String workingDir;

  Future<Plan> resolve(PlanRequest request) async {
    final Version? cliVersion = await PatrolVersions.cli();
    if (cliVersion == null) {
      return Plan.blocked(
        reason:
            'The patrol CLI is not on PATH. Install it with: dart pub global activate patrol_cli',
        request: request,
      );
    }

    final RunnerConfig config = RunnerConfig.load(startDir: workingDir);

    final ({String? projectDir, Plan? stop}) project = _resolveProject(
      request: request,
      config: config,
    );
    final String? projectDir = project.projectDir;
    if (projectDir == null) {
      return project.stop ??
          Plan.blocked(reason: 'No project resolved.', request: request);
    }

    final String testDir = request.testDir == null
        ? PatrolProjects.testDir(projectDir: projectDir, config: config)
        : PatrolInputValidation.requireTestDir(request.testDir ?? '');
    final List<PatrolTestFile> tests = PatrolProjects.tests(
      projectDir: projectDir,
      testDir: testDir,
    );
    if (tests.isEmpty) {
      return Plan.blocked(
        reason: 'No *_test.dart files in $projectDir/$testDir.',
        request: request,
      );
    }

    final ({PatrolTestFile? test, Plan? stop}) test = _resolveTest(
      request: request,
      tests: tests,
      testDir: testDir,
    );
    final PatrolTestFile? testFile = test.test;
    if (testFile == null) {
      return test.stop ??
          Plan.blocked(reason: 'No test resolved.', request: request);
    }

    final ({DeviceCandidate? device, String? unknownId, Plan? stop}) device =
        await _resolveDevice(
          request: request,
          config: config,
          cliVersion: cliVersion,
        );
    final Plan? deviceStop = device.stop;
    if (deviceStop != null) {
      return deviceStop;
    }

    final Plan plan = Plan.ready(request: request)
      ..configPath = config.path
      ..cliVersion = cliVersion
      ..packageVersion = PatrolVersions.package(projectDir: projectDir);
    final DeviceCandidate? candidate = device.device;
    final PatrolPlatform? platform =
        candidate?.platform ?? request.platform ?? config.platform;

    plan
      ..projectDir = projectDir
      ..testDir = testDir
      ..test = testFile
      ..deviceId = candidate?.id ?? device.unknownId
      ..platform = platform
      ..deviceIsVirtual = candidate?.isVirtual ?? false
      ..outputDir =
          request.outputDir ??
          config.outputDir ??
          '$projectDir/$testDir/recordings'
      ..flutterCommand =
          request.flutterCommand ??
          config.flutterCommand ??
          await _defaultFlutterCommand(projectDir)
      ..configPatrolArgs = config.projectConfig(projectDir).argsFor(platform);

    if (device.unknownId != null) {
      plan.warnings.add(
        'Device "${device.unknownId}" is not a connected adb device or a booted '
        'iOS simulator. Patrol checks it when the run starts.',
      );
    }

    final Plan? recorderStop = _chooseRecorder(
      plan: plan,
      cliVersion: cliVersion,
    );
    if (recorderStop != null) {
      return recorderStop;
    }
    _checkPackageVersion(plan: plan, cliVersion: cliVersion);
    return plan;
  }

  ({String? projectDir, Plan? stop}) _resolveProject({
    required PlanRequest request,
    required RunnerConfig config,
  }) {
    final String? requested = request.project;
    if (requested != null) {
      final String path = RunnerConfig.canonical(
        requested.startsWith('/') ? requested : '$workingDir/$requested',
      );
      if (!File('$path/pubspec.yaml').existsSync()) {
        return (
          projectDir: null,
          stop: Plan.blocked(
            reason:
                'No pubspec.yaml in $path. Pass the Flutter app folder with --project.',
            request: request,
          ),
        );
      }
      return (projectDir: path, stop: null);
    }

    final String? configured = config.defaultProject;
    if (configured != null) {
      return (projectDir: configured, stop: null);
    }

    final String cwd = RunnerConfig.canonical(workingDir);
    if (PatrolProjects.isPatrolProject(projectDir: cwd, config: config)) {
      return (projectDir: cwd, stop: null);
    }

    final List<String> projects = PatrolProjects.find(config);
    if (projects.length == 1) {
      return (projectDir: projects.first, stop: null);
    }
    if (projects.isEmpty) {
      return (
        projectDir: null,
        stop: Plan.blocked(
          reason:
              'No Patrol project found in ${config.rootDir}. A Patrol project has '
              'a pubspec.yaml and a patrol_test folder (or patrol.test_directory).',
          request: request,
        ),
      );
    }
    return (
      projectDir: null,
      stop: Plan.ask(
        request: request,
        question: PlanQuestion(
          field: 'project',
          flag: '--project',
          question: 'Which Flutter project holds the test?',
          hint:
              'Set "defaultProject" in ${RunnerConfig.fileName} to skip this question.',
          options: projects
              .map(
                (String path) => PlanOption(
                  value: path,
                  label: PatrolProjects.relative(
                    root: config.rootDir,
                    path: path,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  ({PatrolTestFile? test, Plan? stop}) _resolveTest({
    required PlanRequest request,
    required List<PatrolTestFile> tests,
    required String testDir,
  }) {
    final String? requested = request.test?.replaceAll('\\', '/');
    List<PlanOption> optionsFor(List<PatrolTestFile> files) => files
        .map(
          (PatrolTestFile file) =>
              PlanOption(value: file.relativePath, label: file.marker),
        )
        .toList();

    if (requested == null || requested.isEmpty) {
      return (
        test: null,
        stop: Plan.ask(
          request: request,
          question: PlanQuestion(
            field: 'test',
            flag: '--test',
            question: 'Which test should run?',
            hint: null,
            options: optionsFor(tests),
          ),
        ),
      );
    }

    final String path = requested.startsWith('$testDir/')
        ? requested.substring(testDir.length + 1)
        : requested;
    final List<PatrolTestFile> matches = tests
        .where(
          (PatrolTestFile file) =>
              file.relativePath == path ||
              file.marker == path ||
              file.baseName == path,
        )
        .toList();

    if (matches.length == 1) {
      return (test: matches.first, stop: null);
    }
    return (
      test: null,
      stop: Plan.ask(
        request: request,
        question: PlanQuestion(
          field: 'test',
          flag: '--test',
          question: matches.isEmpty
              ? 'No test matches "$requested". Which test should run?'
              : '"$requested" matches more than one test. Which one should run?',
          hint: null,
          options: optionsFor(matches.isEmpty ? tests : matches),
        ),
      ),
    );
  }

  Future<({DeviceCandidate? device, String? unknownId, Plan? stop})>
  _resolveDevice({
    required PlanRequest request,
    required RunnerConfig config,
    required Version cliVersion,
  }) async {
    final String? requested = request.device;
    final PatrolPlatform? platform = request.platform ?? config.platform;

    if ((requested != null && Devices.webIds.contains(requested)) ||
        platform == PatrolPlatform.web) {
      return (
        device: Devices.web(requested ?? 'chrome'),
        unknownId: null,
        stop: null,
      );
    }

    final List<DeviceCandidate> connected = (await Devices.connected())
        .where(
          (DeviceCandidate device) =>
              platform == null || device.platform == platform,
        )
        .toList();

    if (requested != null) {
      final List<DeviceCandidate> matches = connected
          .where(
            (DeviceCandidate device) =>
                device.id == requested || device.name == requested,
          )
          .toList();
      if (matches.length == 1) {
        return (device: matches.first, unknownId: null, stop: null);
      }
      if (matches.isEmpty) {
        return (
          device: null,
          unknownId: PatrolInputValidation.requireDeviceId(requested),
          stop: null,
        );
      }
      return (
        device: null,
        unknownId: null,
        stop: _askDevice(
          request: request,
          options: matches,
          question: '"$requested" matches more than one device. Which one?',
          cliVersion: cliVersion,
        ),
      );
    }

    if (connected.length == 1) {
      return (device: connected.first, unknownId: null, stop: null);
    }
    return (
      device: null,
      unknownId: null,
      stop: _askDevice(
        request: request,
        options: connected,
        question: connected.isEmpty
            ? 'No device is connected. Which device should the test run on?'
            : 'Which device should the test run on?',
        cliVersion: cliVersion,
      ),
    );
  }

  Plan _askDevice({
    required PlanRequest request,
    required List<DeviceCandidate> options,
    required String question,
    required Version cliVersion,
  }) {
    final bool webAllowed =
        cliVersion.isAtLeast(PatrolVersions.web) &&
        (request.platform == null || request.platform == PatrolPlatform.web);
    final List<PlanOption> planOptions = <PlanOption>[
      for (final DeviceCandidate device in options)
        PlanOption(value: device.id, label: device.label),
      if (webAllowed) const PlanOption(value: 'chrome', label: 'chrome | web'),
    ];
    if (planOptions.isEmpty) {
      return Plan.blocked(
        reason:
            'No device found. Start an Android emulator or boot an iOS simulator, then plan again.',
        request: request,
      );
    }
    return Plan.ask(
      request: request,
      question: PlanQuestion(
        field: 'device',
        flag: '--device',
        question: question,
        hint: options.isEmpty
            ? 'To test on Android or iOS, start an emulator or boot a simulator, then plan again.'
            : null,
        options: planOptions,
      ),
    );
  }

  Plan? _chooseRecorder({required Plan plan, required Version cliVersion}) {
    final List<String> userArgs = plan.patrolArgs;
    bool hasFlag(String name) => userArgs.any(
      (String argument) => argument == name || argument.startsWith('$name='),
    );

    if (plan.request.noRecord) {
      plan
        ..recorder = RecorderType.none
        ..recorderReason = '--no-record';
      return null;
    }

    switch (plan.platform) {
      case PatrolPlatform.web:
        if (!cliVersion.isAtLeast(PatrolVersions.web)) {
          return Plan.blocked(
            reason:
                'Patrol CLI $cliVersion cannot run web tests. Web needs ${PatrolVersions.web} or later.',
            request: plan.request,
          );
        }
        plan
          ..recorder = RecorderType.playwright
          ..recorderReason = hasFlag('--web-video')
              ? 'Playwright video, mode set in the patrol arguments'
              : 'Patrol CLI $cliVersion supports --web-video (since ${PatrolVersions.web})';
      case PatrolPlatform.android:
        _chooseNativeRecorder(
          plan: plan,
          cliVersion: cliVersion,
          fallback: RecorderType.watcherAdb,
          userSetRecordVideo: hasFlag('--record-video'),
        );
      case PatrolPlatform.ios when plan.deviceIsVirtual:
        _chooseNativeRecorder(
          plan: plan,
          cliVersion: cliVersion,
          fallback: RecorderType.watcherSimctl,
          userSetRecordVideo: hasFlag('--record-video'),
        );
      case PatrolPlatform.ios:
        plan
          ..recorder = RecorderType.none
          ..recorderReason = 'Physical iOS devices cannot be recorded';
        plan.warnings.add(
          'This run has no video. Physical iOS devices cannot be recorded.',
        );
      case null:
        plan
          ..recorder = RecorderType.none
          ..recorderReason = 'Unknown platform for device ${plan.deviceId}';
        plan.warnings.add(
          'This run has no video. Pass --platform to record an unlisted device.',
        );
    }
    return null;
  }

  void _chooseNativeRecorder({
    required Plan plan,
    required Version cliVersion,
    required RecorderType fallback,
    required bool userSetRecordVideo,
  }) {
    if (userSetRecordVideo) {
      plan
        ..recorder = RecorderType.patrolCli
        ..recorderReason = '--record-video is set in the patrol arguments';
      return;
    }
    if (cliVersion.isAtLeast(PatrolVersions.recordVideo)) {
      plan
        ..recorder = RecorderType.patrolCli
        ..recorderReason =
            'Patrol CLI $cliVersion supports --record-video (since ${PatrolVersions.recordVideo})';
      return;
    }
    plan
      ..recorder = fallback
      ..recorderReason =
          'Patrol CLI $cliVersion is older than ${PatrolVersions.recordVideo}, which added --record-video';
  }

  void _checkPackageVersion({required Plan plan, required Version cliVersion}) {
    final Version? package = plan.packageVersion;
    if (package != null &&
        cliVersion.isAtLeast(PatrolVersions.recordVideo) &&
        !package.isAtLeast(PatrolVersions.packageForRecordVideoCli)) {
      plan.warnings.add(
        'Patrol CLI $cliVersion needs the patrol package '
        '${PatrolVersions.packageForRecordVideoCli} or later, but the project '
        'resolves $package. Patrol will likely refuse to run.',
      );
    }
  }

  Future<String> _defaultFlutterCommand(String projectDir) async {
    Directory directory = Directory(projectDir);
    while (true) {
      if (File('${directory.path}/.fvmrc').existsSync() ||
          File('${directory.path}/.fvm/fvm_config.json').existsSync()) {
        return await Tools.isOnPath('fvm') ? 'fvm flutter' : 'flutter';
      }
      final Directory parent = directory.parent;
      if (parent.path == directory.path) {
        return 'flutter';
      }
      directory = parent;
    }
  }
}
