/// Finds devices, tool versions and the video recorder for each platform.
library;

import 'dart:convert';
import 'dart:io';

enum PatrolPlatform {
  android,
  ios,
  web;

  static PatrolPlatform parse(String value) {
    return PatrolPlatform.values.firstWhere(
      (PatrolPlatform platform) => platform.name == value,
      orElse: () => throw ArgumentError(
        'Invalid platform "$value": use android, ios or web.',
      ),
    );
  }
}

enum RecorderType {
  patrolCli('patrol-cli'),
  playwright('playwright'),
  watcherAdb('watcher-adb'),
  watcherSimctl('watcher-simctl'),
  none('none');

  const RecorderType(this.id);

  final String id;

  bool get usesWatcher => this == watcherAdb || this == watcherSimctl;
}

final class Version implements Comparable<Version> {
  const Version(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  static Version? tryParse(String value) {
    final RegExpMatch? match = RegExp(r'(\d+)\.(\d+)\.(\d+)').firstMatch(value);
    if (match == null) {
      return null;
    }
    return Version(
      int.parse(match.group(1) ?? '0'),
      int.parse(match.group(2) ?? '0'),
      int.parse(match.group(3) ?? '0'),
    );
  }

  bool isAtLeast(Version other) => compareTo(other) >= 0;

  @override
  int compareTo(Version other) {
    if (major != other.major) {
      return major.compareTo(other.major);
    }
    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }
    return patch.compareTo(other.patch);
  }

  @override
  String toString() => '$major.$minor.$patch';
}

abstract final class PatrolVersions {
  /// Patrol CLI 4.0.0 added web runs and `--web-video`.
  static const Version web = Version(4, 0, 0);

  /// Patrol CLI 4.7.0 added `--record-video` for Android and iOS simulators,
  /// and fixed reading iOS simulator logs.
  static const Version recordVideo = Version(4, 7, 0);

  /// Patrol CLI 4.7.0 and later need the patrol package 4.9.0 or later.
  static const Version packageForRecordVideoCli = Version(4, 9, 0);

  static Future<Version?> cli() async {
    if (!await Tools.isOnPath('patrol')) {
      return null;
    }
    final ProcessResult result = await Process.run('patrol', <String>[
      '--version',
    ]);
    final RegExpMatch? match = RegExp(
      r'patrol_cli v(\d+\.\d+\.\d+)',
    ).firstMatch('${result.stdout}\n${result.stderr}');
    return match == null ? null : Version.tryParse(match.group(1) ?? '');
  }

  /// Reads the patrol package version from the nearest pubspec.lock.
  static Version? package({required String projectDir}) {
    Directory directory = Directory(projectDir);
    while (true) {
      final File lock = File('${directory.path}/pubspec.lock');
      if (lock.existsSync()) {
        final RegExpMatch? match = RegExp(
          r'\n  patrol:\n(?:    .*\n)*?    version: "([^"]+)"',
        ).firstMatch(lock.readAsStringSync());
        return match == null ? null : Version.tryParse(match.group(1) ?? '');
      }
      final Directory parent = directory.parent;
      if (parent.path == directory.path) {
        return null;
      }
      directory = parent;
    }
  }
}

final class DeviceCandidate {
  const DeviceCandidate({
    required this.id,
    required this.name,
    required this.platform,
    required this.isVirtual,
  });

  final String id;
  final String name;
  final PatrolPlatform platform;
  final bool isVirtual;

  String get label => '$id | $name | ${platform.name}';
}

abstract final class Devices {
  static const Set<String> webIds = <String>{'chrome', 'edge', 'web-server'};

  static Future<List<DeviceCandidate>> connected() async {
    return <DeviceCandidate>[
      ...await _adbDevices(),
      ...await _bootedSimulators(),
    ];
  }

  static DeviceCandidate web(String id) {
    return DeviceCandidate(
      id: id,
      name: 'browser',
      platform: PatrolPlatform.web,
      isVirtual: true,
    );
  }

  static Future<List<DeviceCandidate>> _adbDevices() async {
    if (!await Tools.isOnPath('adb')) {
      return <DeviceCandidate>[];
    }
    final ProcessResult result = await Process.run('adb', <String>[
      'devices',
      '-l',
    ]);
    if (result.exitCode != 0) {
      return <DeviceCandidate>[];
    }
    final List<DeviceCandidate> devices = <DeviceCandidate>[];
    for (final String line in result.stdout.toString().split('\n').skip(1)) {
      final List<String> parts = line.trim().split(RegExp(r'\s+'));
      if (parts.length < 2 || parts[1] != 'device') {
        continue;
      }
      final String id = parts.first;
      final String model = parts
          .firstWhere(
            (String part) => part.startsWith('model:'),
            orElse: () => 'model:android',
          )
          .substring('model:'.length);
      devices.add(
        DeviceCandidate(
          id: id,
          name: model,
          platform: PatrolPlatform.android,
          isVirtual: id.startsWith('emulator-'),
        ),
      );
    }
    return devices;
  }

  static Future<List<DeviceCandidate>> _bootedSimulators() async {
    if (!Platform.isMacOS || !await Tools.isOnPath('xcrun')) {
      return <DeviceCandidate>[];
    }
    final ProcessResult result = await Process.run('xcrun', <String>[
      'simctl',
      'list',
      'devices',
      'booted',
      '-j',
    ]);
    if (result.exitCode != 0) {
      return <DeviceCandidate>[];
    }

    final Object? decoded = jsonDecode(result.stdout.toString());
    if (decoded is! Map<String, Object?>) {
      return <DeviceCandidate>[];
    }
    final Object? runtimes = decoded['devices'];
    if (runtimes is! Map<String, Object?>) {
      return <DeviceCandidate>[];
    }

    final List<DeviceCandidate> simulators = <DeviceCandidate>[];
    for (final Object? devices in runtimes.values) {
      if (devices is! List<Object?>) {
        continue;
      }
      for (final Object? device in devices) {
        if (device is! Map<String, Object?>) {
          continue;
        }
        final Object? udid = device['udid'];
        final Object? name = device['name'];
        if (device['state'] == 'Booted' && udid is String && name is String) {
          simulators.add(
            DeviceCandidate(
              id: udid,
              name: name,
              platform: PatrolPlatform.ios,
              isVirtual: true,
            ),
          );
        }
      }
    }
    return simulators;
  }
}

abstract final class Tools {
  static Future<bool> isOnPath(String executable) async {
    final ProcessResult result = await Process.run(
      Platform.isWindows ? 'where' : 'which',
      <String>[executable],
    );
    return result.exitCode == 0;
  }

  /// Quotes [value] for a POSIX shell when it holds special characters.
  static String shellQuote(String value) {
    if (RegExp(r'^[a-zA-Z0-9_./:=@%+,-]+$').hasMatch(value)) {
      return value;
    }
    return "'${value.replaceAll("'", r"'\''")}'";
  }
}
