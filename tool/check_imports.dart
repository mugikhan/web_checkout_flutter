import 'dart:io';

void main() {
  final modules = Directory('modules');
  if (!modules.existsSync()) return;

  final directive = RegExp(r'''^\s*(import|export)\s+['"]([^'"]+)['"]''');
  final forbidden = RegExp(r'^package:api/(data|src)/|packages/api/lib/');
  final hits = <String>[];

  final files = modules
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.contains('${Platform.pathSeparator}.dart_tool'));
  for (final file in files) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final uri = directive.firstMatch(lines[i])?.group(2);
      if (uri != null && forbidden.hasMatch(uri)) {
        hits.add('${file.path}:${i + 1}: $uri');
      }
    }
  }

  if (hits.isEmpty) {
    stdout.writeln('Import boundary: no module imports the api data layer.');
    return;
  }
  stderr
    ..writeln('Modules may import package:api/domain/domain.dart only:')
    ..writeAll(hits.map((h) => '  $h\n'));
  exitCode = 1;
}
