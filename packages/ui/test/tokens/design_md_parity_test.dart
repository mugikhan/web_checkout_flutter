import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui/ui.dart';

void main() {
  final rowPattern = RegExp(
    r'^\| `(\w+)` \| `#([0-9A-F]{6})` \| `#([0-9A-F]{6})` \|',
    multiLine: true,
  );
  final rows = {
    for (final m in rowPattern.allMatches(
      File('../../DESIGN.md').readAsStringSync(),
    ))
      m[1]!: (light: m[2]!, dark: m[3]!),
  };

  String hex(Color c) =>
      c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();

  test('DESIGN.md lists every AppColors role and nothing else', () {
    expect(rows.keys.toSet(), AppColors.light.byRole.keys.toSet());
  });

  for (final (theme, colors) in [
    ('light', AppColors.light),
    ('dark', AppColors.dark),
  ]) {
    group('$theme colours match DESIGN.md', () {
      for (final MapEntry(key: role, value: color) in colors.byRole.entries) {
        test(role, () {
          final row = rows[role];
          expect(row, isNotNull, reason: '$role is missing from DESIGN.md');
          expect(hex(color), theme == 'light' ? row!.light : row!.dark);
        });
      }
    });
  }
}
