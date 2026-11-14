/// Validates user-supplied values before they reach [Process.start].
library;

final class PatrolInputValidation {
  PatrolInputValidation._();

  // Allow ":" for wireless adb ids such as 192.168.1.5:5555, and spaces and
  // brackets for simulator names such as "iPhone 16 Pro (2)".
  static final RegExp _deviceId = RegExp(r'^[a-zA-Z0-9._: ()-]+$');
  static final RegExp _testMarker = RegExp(r'^[a-zA-Z0-9_]+$');
  static final RegExp _relativeDir = RegExp(r'^[a-zA-Z0-9_./-]+$');
  static final RegExp _remotePath = RegExp(
    r'^/sdcard/patrol_[a-zA-Z0-9_]+\.mp4$',
  );

  static String requireDeviceId(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty || !_deviceId.hasMatch(trimmed)) {
      throw ArgumentError(
        'Invalid device id "$value": use only letters, numbers, spaces and ". _ : ( ) -".',
      );
    }
    return trimmed;
  }

  static String requireTestMarker(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty || !_testMarker.hasMatch(trimmed)) {
      throw ArgumentError(
        'Invalid test marker "$value": use only letters, numbers and underscores.',
      );
    }
    return trimmed;
  }

  static String requireTestDir(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty ||
        !_relativeDir.hasMatch(trimmed) ||
        trimmed.startsWith('/') ||
        trimmed.contains('..')) {
      throw ArgumentError(
        'Invalid test directory "$value": use a path relative to the project.',
      );
    }
    return trimmed;
  }

  // Processes start without a shell, so spaces are safe. Reject only control
  // characters and a leading "-", which a tool could read as a flag.
  static String requirePath(String value, {required String label}) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty ||
        trimmed.startsWith('-') ||
        trimmed.contains(RegExp(r'[\x00-\x1F]'))) {
      throw ArgumentError('Invalid $label "$value".');
    }
    return trimmed;
  }

  static String requireRemoteRecordingPath(String value) {
    if (!_remotePath.hasMatch(value)) {
      throw ArgumentError('Invalid remote recording path "$value".');
    }
    return value;
  }

  static int requireTimeoutSec(int value) {
    if (value < 1 || value > 7200) {
      throw ArgumentError('Invalid timeout: use 1 to 7200 seconds.');
    }
    return value;
  }

  static double requirePollSec(double value) {
    if (value <= 0 || value > 60) {
      throw ArgumentError(
        'Invalid poll interval: use more than 0 and at most 60 seconds.',
      );
    }
    return value;
  }
}
