// ignore_for_file: avoid_print

/// Watches a Patrol CLI log and records the device screen during the test.
///
/// Android uses adb screenrecord. iOS simulators use xcrun simctl recordVideo.
/// The runner (run_patrol_test.dart) starts this script. To use it alone:
/// ```
/// dart run patrol_screenrecord.dart --platform ios --device <simulator udid> \
///   --marker login_page --output-dir /path/to/app/patrol_test/recordings \
///   --log-file /tmp/patrol_login_page.log
/// ```
library;

import 'dart:async';
import 'dart:io';

import 'patrol_input_validation.dart';
import 'patrol_platform.dart';

Future<void> main(List<String> arguments) async {
  final PatrolScreenRecordOptions options;
  try {
    options = PatrolScreenRecordOptions.parse(arguments);
  } on ArgumentError catch (error) {
    stderr.writeln('[screenrecord] ${error.message}');
    exit(64);
  }
  await PatrolScreenRecord(options).run();
  // The signal listeners keep the isolate alive, so exit on purpose.
  exit(0);
}

final class PatrolScreenRecordOptions {
  const PatrolScreenRecordOptions({
    required this.platform,
    required this.device,
    required this.testMarker,
    required this.outputDir,
    required this.timeoutSec,
    required this.pollSec,
    required this.patrolLogFile,
    required this.stopFile,
    required this.startImmediately,
  });

  final PatrolPlatform platform;
  final String device;
  final String testMarker;
  final String outputDir;
  final int timeoutSec;
  final double pollSec;
  final String? patrolLogFile;
  final String? stopFile;
  final bool startImmediately;

  static PatrolScreenRecordOptions parse(List<String> arguments) {
    PatrolPlatform platform = PatrolPlatform.android;
    String? device;
    String? testMarker;
    String? outputDir;
    int timeoutSec = 900;
    double pollSec = 0.2;
    String? patrolLogFile;
    String? stopFile;
    bool startImmediately = false;

    for (int index = 0; index < arguments.length; index++) {
      final String argument = arguments[index];
      switch (argument) {
        case '--platform':
          platform = PatrolPlatform.parse(
            _requireValue(arguments: arguments, index: index, flag: argument),
          );
          index++;
        case '--device':
          device = _requireValue(
            arguments: arguments,
            index: index,
            flag: argument,
          );
          index++;
        case '--marker':
          testMarker = _requireValue(
            arguments: arguments,
            index: index,
            flag: argument,
          );
          index++;
        case '--output-dir':
          outputDir = _requireValue(
            arguments: arguments,
            index: index,
            flag: argument,
          );
          index++;
        case '--timeout-sec':
          timeoutSec = int.parse(
            _requireValue(arguments: arguments, index: index, flag: argument),
          );
          index++;
        case '--poll-sec':
          pollSec = double.parse(
            _requireValue(arguments: arguments, index: index, flag: argument),
          );
          index++;
        case '--log-file':
          patrolLogFile = _requireValue(
            arguments: arguments,
            index: index,
            flag: argument,
          );
          index++;
        case '--stop-file':
          stopFile = _requireValue(
            arguments: arguments,
            index: index,
            flag: argument,
          );
          index++;
        case '--start-immediately':
          startImmediately = true;
        case '--help':
        case '-h':
          _printUsage();
          exit(0);
        default:
          throw ArgumentError('Unknown argument: $argument');
      }
    }

    if (device == null || testMarker == null || outputDir == null) {
      throw ArgumentError('--device, --marker and --output-dir are required.');
    }
    if (platform == PatrolPlatform.web) {
      throw ArgumentError(
        'Web runs record through Playwright. The watcher supports android and ios.',
      );
    }
    if (platform == PatrolPlatform.ios &&
        patrolLogFile == null &&
        !startImmediately) {
      throw ArgumentError(
        'iOS needs --log-file, or --start-immediately with --stop-file.',
      );
    }

    return PatrolScreenRecordOptions(
      platform: platform,
      device: PatrolInputValidation.requireDeviceId(device),
      testMarker: PatrolInputValidation.requireTestMarker(testMarker),
      outputDir: PatrolInputValidation.requirePath(
        outputDir,
        label: 'output directory',
      ),
      timeoutSec: PatrolInputValidation.requireTimeoutSec(timeoutSec),
      pollSec: PatrolInputValidation.requirePollSec(pollSec),
      patrolLogFile: patrolLogFile == null
          ? null
          : PatrolInputValidation.requirePath(patrolLogFile, label: 'log file'),
      stopFile: stopFile == null
          ? null
          : PatrolInputValidation.requirePath(stopFile, label: 'stop file'),
      startImmediately: startImmediately,
    );
  }

  static String _requireValue({
    required List<String> arguments,
    required int index,
    required String flag,
  }) {
    if (index + 1 >= arguments.length) {
      throw ArgumentError('Missing value for $flag');
    }
    return arguments[index + 1];
  }

  static void _printUsage() {
    print('''
Watch a Patrol CLI log and record the device screen during the test.

Usage:
  dart run patrol_screenrecord.dart --device <id> --marker <name> --output-dir <path> [options]

Options:
  --platform <name>       android (adb screenrecord) or ios (simulator only)
                          (default: android)
  --device <id>           adb device id, or iOS simulator UDID (required)
  --marker <name>         test file name without _test.dart (required)
  --output-dir <path>     folder for the mp4 files (required)
  --log-file <path>       Patrol CLI log to watch (required for iOS; on Android,
                          falls back to logcat without it)
  --timeout-sec <n>       stop watching after n seconds (default: 900)
  --poll-sec <n>          poll interval in seconds (default: 0.2)
  --stop-file <path>      stop and save when this file appears
  --start-immediately     record from launch instead of waiting for the 🧪 line
''');
  }
}

abstract interface class ScreenRecorder {
  Future<void> start();

  /// Stops the capture and returns true when a local file exists.
  Future<bool> stop();
}

final class PatrolScreenRecord {
  PatrolScreenRecord(this.options);

  final PatrolScreenRecordOptions options;

  bool _recording = false;
  bool _loggedWaitingForStart = false;
  bool _loggedWaitingForFinish = false;
  late final String _localPath;
  late final ScreenRecorder _recorder;

  static final RegExp _startPattern = RegExp('🧪');
  static final RegExp _finishPattern = RegExp(
    r'Test summary:|All tests were executed|✅ Successful:|❌ Failed:|FAILURES!!!|Process crashed',
  );

  String get _completionMarkerPath =>
      '${options.outputDir}/.patrol_${options.testMarker}.recording.complete';

  Future<void> run() async {
    Directory(options.outputDir).createSync(recursive: true);

    final String timestamp = _timestamp();
    _localPath = '${options.outputDir}/${options.testMarker}_$timestamp.mp4';
    _recorder = switch (options.platform) {
      PatrolPlatform.ios => IosSimulatorRecorder(
        udid: options.device,
        localPath: _localPath,
      ),
      _ => AndroidScreenRecorder(
        device: options.device,
        localPath: _localPath,
        remotePath: PatrolInputValidation.requireRemoteRecordingPath(
          '/sdcard/patrol_${options.testMarker}_$timestamp.mp4',
        ),
        warnTimeLimit: options.timeoutSec > AndroidScreenRecorder.timeLimitSec,
      ),
    };

    final File completionMarker = File(_completionMarkerPath);
    if (completionMarker.existsSync()) {
      completionMarker.deleteSync();
    }

    ProcessSignal.sigint.watch().listen((_) => _stopAndExit());
    if (!Platform.isWindows) {
      ProcessSignal.sigterm.watch().listen((_) => _stopAndExit());
    }

    if (options.platform == PatrolPlatform.android) {
      await Process.run('adb', <String>['-s', options.device, 'logcat', '-c']);
    }

    print('[screenrecord] Ready. Recording starts when the test starts.');
    print(
      '[screenrecord] Platform: ${options.platform.name} | device: ${options.device} | '
      'marker: ${options.testMarker} | output: $_localPath',
    );

    final String? logFile = options.patrolLogFile;
    if (logFile != null) {
      print('[screenrecord] Watching Patrol log: $logFile');
    } else {
      print(
        '[screenrecord] No --log-file. Watching device logcat instead (less reliable).',
      );
    }

    final DateTime deadline = DateTime.now().add(
      Duration(seconds: options.timeoutSec),
    );

    if (options.startImmediately) {
      print('[screenrecord] Recording from launch (--start-immediately).');
      await _recorder.start();
      _recording = true;
    }

    while (DateTime.now().isBefore(deadline)) {
      if (_stopRequested()) {
        print('[screenrecord] Runner asked to stop. Saving the capture.');
        await _stopRecording();
        await _signalCompletion(success: _recordedAnything);
        return;
      }
      if (_recording) {
        if (!_loggedWaitingForFinish) {
          print('[screenrecord] Recording. Waiting for "Test summary"…');
          _loggedWaitingForFinish = true;
        }
        if (_finishPattern.hasMatch(await _readSignalSource(logcatLines: 80))) {
          print('[screenrecord] Test finished. Stopping capture.');
          await _stopRecording();
          await _signalCompletion(success: true);
          return;
        }
      } else {
        if (!_loggedWaitingForStart) {
          print(
            '[screenrecord] Waiting for the test to start (Patrol prints a 🧪 line)…',
          );
          _loggedWaitingForStart = true;
        }
        if (_startPattern.hasMatch(await _readSignalSource(logcatLines: 50))) {
          print('[screenrecord] Test started. Recording.');
          await _recorder.start();
          _recording = true;
        }
      }
      await Future<void>.delayed(
        Duration(milliseconds: (options.pollSec * 1000).round()),
      );
    }

    print(
      '[screenrecord] Timed out after ${options.timeoutSec}s. Saving a partial capture.',
    );
    await _stopRecording();
    await _signalCompletion(success: false);
  }

  bool _recordedAnything = false;

  bool _stopRequested() {
    final String? path = options.stopFile;
    return path != null && File(path).existsSync();
  }

  Future<void> _stopAndExit() async {
    await _stopRecording();
    exit(0);
  }

  Future<void> _stopRecording() async {
    if (!_recording) {
      return;
    }
    _recording = false;
    _recordedAnything = true;

    final bool saved = await _recorder.stop();
    if (!saved) {
      print('[screenrecord] Warning: no recording file at $_localPath');
      return;
    }
    if (await RecordingFiles.isPlayableMp4(_localPath)) {
      await RecordingFiles.normalize(localPath: _localPath);
    } else {
      print(
        '[screenrecord] Warning: the MP4 does not play (no moov atom). '
        'The capture was probably cut short. Run the test again.',
      );
    }
    print('[screenrecord] Saved: $_localPath');
  }

  Future<String> _readSignalSource({required int logcatLines}) async {
    final String? logPath = options.patrolLogFile;
    if (logPath != null) {
      final File logFile = File(logPath);
      if (!logFile.existsSync()) {
        return '';
      }
      return logFile.readAsString();
    }
    if (options.platform == PatrolPlatform.ios) {
      return '';
    }

    final ProcessResult result = await Process.run('adb', <String>[
      '-s',
      options.device,
      'logcat',
      '-s',
      'flutter:I',
      '-v',
      'brief',
      '-t',
      '$logcatLines',
    ]);
    return result.stdout.toString();
  }

  Future<void> _signalCompletion({required bool success}) async {
    if (success && File(_localPath).existsSync()) {
      await File(_completionMarkerPath).writeAsString(_localPath);
    }
    print('[screenrecord] Done${success ? '' : ' (with errors)'}');
  }

  String _timestamp() {
    final DateTime now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${now.year}${two(now.month)}${two(now.day)}_'
        '${two(now.hour)}${two(now.minute)}${two(now.second)}';
  }
}

final class AndroidScreenRecorder implements ScreenRecorder {
  AndroidScreenRecorder({
    required this.device,
    required this.localPath,
    required this.remotePath,
    required this.warnTimeLimit,
  });

  final String device;
  final String localPath;
  final String remotePath;
  final bool warnTimeLimit;

  // Android caps one screenrecord session at 180 seconds.
  static const int timeLimitSec = 180;
  static const Duration _adbShellExitTimeout = Duration(seconds: 10);
  static const Duration _screenrecordStopTimeout = Duration(seconds: 3);
  static const Duration _remoteFileReadyTimeout = Duration(seconds: 2);
  static const Duration _pollInterval = Duration(milliseconds: 200);

  Process? _screenrecordProcess;

  @override
  Future<void> start() async {
    print('[screenrecord] adb screenrecord → $remotePath');
    if (warnTimeLimit) {
      print(
        '[screenrecord] Note: Android stops screenrecord after ${timeLimitSec}s. '
        'A longer test keeps only the first ${timeLimitSec}s.',
      );
    }
    await _runAdb(<String>['logcat', '-c']);
    await _runAdbShell(<String>['rm', '-f', remotePath]);
    await _runAdbShell(<String>['pkill', '-INT', 'screenrecord']);

    _screenrecordProcess = await Process.start('adb', <String>[
      '-s',
      device,
      'shell',
      'screenrecord',
      '--time-limit',
      '$timeLimitSec',
      remotePath,
    ]);
  }

  @override
  Future<bool> stop() async {
    print('[screenrecord] Sending SIGINT so the device finalizes the MP4…');

    // Stop screenrecord on the device first. Killing the local adb shell
    // first truncates the file and drops the MP4 moov atom.
    await _runAdbShell(<String>['pkill', '-INT', 'screenrecord']);

    final Process? adbShell = _screenrecordProcess;
    _screenrecordProcess = null;

    bool adbShellExitedCleanly = false;
    if (adbShell != null) {
      try {
        await adbShell.exitCode.timeout(_adbShellExitTimeout);
        adbShellExitedCleanly = true;
      } on TimeoutException {
        print(
          '[screenrecord] Warning: adb shell did not exit after SIGINT. Forcing stop.',
        );
        adbShell.kill();
      }
    }

    if (adbShellExitedCleanly) {
      await Future<void>.delayed(_pollInterval);
    } else {
      await _waitUntilScreenrecordStopped();
    }
    await _waitForRemoteFileReady();

    print('[screenrecord] Pulling recording → $localPath');
    final ProcessResult pullResult = await _runAdb(<String>[
      'pull',
      remotePath,
      localPath,
    ]);
    await _runAdbShell(<String>['rm', '-f', remotePath]);

    if (pullResult.exitCode != 0) {
      final String error = pullResult.stderr.toString().trim();
      print('[screenrecord] Warning: could not pull $remotePath. $error');
    }
    return File(localPath).existsSync();
  }

  Future<void> _waitUntilScreenrecordStopped() async {
    final DateTime deadline = DateTime.now().add(_screenrecordStopTimeout);
    while (DateTime.now().isBefore(deadline)) {
      final ProcessResult result = await _runAdbShell(<String>[
        'pgrep',
        '-x',
        'screenrecord',
      ]);
      if (result.exitCode != 0) {
        return;
      }
      await Future<void>.delayed(_pollInterval);
    }
  }

  Future<void> _waitForRemoteFileReady() async {
    final DateTime deadline = DateTime.now().add(_remoteFileReadyTimeout);
    int? previousSize;
    while (DateTime.now().isBefore(deadline)) {
      final ProcessResult statResult = await _runAdbShell(<String>[
        'stat',
        '-c',
        '%s',
        remotePath,
      ]);
      if (statResult.exitCode == 0) {
        final int? size = int.tryParse(statResult.stdout.toString().trim());
        if (size != null && size > 0 && size == previousSize) {
          return;
        }
        previousSize = size;
      }
      await Future<void>.delayed(_pollInterval);
    }
  }

  Future<ProcessResult> _runAdb(List<String> arguments) {
    return Process.run('adb', <String>['-s', device, ...arguments]);
  }

  Future<ProcessResult> _runAdbShell(List<String> arguments) {
    return Process.run('adb', <String>['-s', device, 'shell', ...arguments]);
  }
}

final class IosSimulatorRecorder implements ScreenRecorder {
  IosSimulatorRecorder({required this.udid, required this.localPath});

  final String udid;
  final String localPath;

  static const Duration _stopTimeout = Duration(seconds: 15);

  Process? _recordProcess;

  @override
  Future<void> start() async {
    print('[screenrecord] xcrun simctl recordVideo → $localPath');

    // A simulator allows one recording at a time. Stop one left by a killed run.
    await Process.run('pkill', <String>[
      '-INT',
      '-f',
      'simctl io $udid recordVideo',
    ]);

    final Process process = await Process.start('xcrun', <String>[
      'simctl',
      'io',
      udid,
      'recordVideo',
      '--codec=h264',
      '--force',
      localPath,
    ]);
    process.stdout.listen((_) {});
    process.stderr.listen(
      (List<int> data) =>
          stdout.write('[screenrecord] simctl: ${String.fromCharCodes(data)}'),
    );
    _recordProcess = process;
  }

  @override
  Future<bool> stop() async {
    final Process? process = _recordProcess;
    _recordProcess = null;
    if (process == null) {
      return File(localPath).existsSync();
    }

    // SIGINT lets simctl write the MP4 trailer. SIGTERM leaves a broken file.
    print('[screenrecord] Sending SIGINT so simctl finalizes the MP4…');
    process.kill(ProcessSignal.sigint);
    try {
      await process.exitCode.timeout(_stopTimeout);
    } on TimeoutException {
      print(
        '[screenrecord] Warning: simctl did not exit after SIGINT. Forcing stop.',
      );
      process.kill();
    }
    return File(localPath).existsSync();
  }
}

abstract final class RecordingFiles {
  static Future<bool> isPlayableMp4(String path) async {
    if (!await Tools.isOnPath('ffprobe')) {
      print('[screenrecord] ffprobe not found. Skipping the playback check.');
      return true;
    }

    final ProcessResult probeResult = await Process.run('ffprobe', <String>[
      '-v',
      'error',
      '-show_entries',
      'format=duration',
      '-of',
      'default=noprint_wrappers=1:nokey=1',
      path,
    ]);
    return probeResult.exitCode == 0 &&
        probeResult.stdout.toString().trim().isNotEmpty;
  }

  // Some recorders write the moov atom last, so QuickTime and browsers cannot
  // stream the raw file. A +faststart remux moves it to the front.
  static Future<void> normalize({required String localPath}) async {
    if (!await Tools.isOnPath('ffmpeg')) {
      print('[screenrecord] ffmpeg not found. Keeping the raw MP4.');
      return;
    }

    final String normalizedPath =
        '${Directory.systemTemp.path}/patrol_normalized_'
        '${DateTime.now().millisecondsSinceEpoch}.mp4';

    final bool remuxed = await _runFfmpeg(
      outputPath: normalizedPath,
      arguments: <String>[
        '-y',
        '-v',
        'warning',
        '-i',
        localPath,
        '-an',
        '-c:v',
        'copy',
        '-movflags',
        '+faststart',
      ],
    );

    if (!remuxed) {
      print('[screenrecord] Remux failed. Re-encoding with libx264 (slower)…');
      final bool reencoded = await _runFfmpeg(
        outputPath: normalizedPath,
        arguments: <String>[
          '-y',
          '-v',
          'warning',
          '-fflags',
          '+genpts',
          '-i',
          localPath,
          '-an',
          '-vf',
          'fps=30',
          '-c:v',
          'libx264',
          '-preset',
          'veryfast',
          '-pix_fmt',
          'yuv420p',
          '-movflags',
          '+faststart',
        ],
      );
      if (!reencoded) {
        _deleteIfExists(normalizedPath);
        print(
          '[screenrecord] Warning: normalization failed. Keeping the raw MP4.',
        );
        return;
      }
    }

    await File(normalizedPath).copy(localPath);
    _deleteIfExists(normalizedPath);
  }

  static Future<bool> _runFfmpeg({
    required String outputPath,
    required List<String> arguments,
  }) async {
    final ProcessResult result = await Process.run('ffmpeg', <String>[
      ...arguments,
      outputPath,
    ]);
    if (result.exitCode != 0) {
      _deleteIfExists(outputPath);
      final String error = result.stderr.toString().trim();
      if (error.isNotEmpty) {
        print('[screenrecord] ffmpeg: $error');
      }
      return false;
    }
    return File(outputPath).existsSync();
  }

  static void _deleteIfExists(String path) {
    final File file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
