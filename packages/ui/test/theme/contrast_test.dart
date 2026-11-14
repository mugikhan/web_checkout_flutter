import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui/ui.dart';

import '../support/test_text_theme.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final (name, theme) in [
    ('light', AppTheme.light(textTheme: testTextTheme)),
    ('dark', AppTheme.dark(textTheme: testTextTheme)),
  ]) {
    group('$name pairs meet WCAG AA (4.5:1)', () {
      final s = theme.colorScheme;
      final t = theme.extension<AppTokens>()!;
      final pairs = {
        'onSurface / surface': (s.onSurface, s.surface),
        'onSurface / surfaceContainer': (s.onSurface, s.surfaceContainer),
        'onSurfaceVariant / surface': (s.onSurfaceVariant, s.surface),
        'onPrimary / primary': (s.onPrimary, s.primary),
        'onSecondary / secondary': (s.onSecondary, s.secondary),
        'onTertiary / tertiary': (s.onTertiary, s.tertiary),
        'onError / error': (s.onError, s.error),
        'onErrorContainer / errorContainer': (
          s.onErrorContainer,
          s.errorContainer,
        ),
        'error / surface': (s.error, s.surface),
        'onBrandLime / brandLime': (t.onBrandLime, t.brandLime),
      };
      for (final MapEntry(key: label, value: (fg, bg)) in pairs.entries) {
        test(label, () {
          expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
        });
      }
    });
  }

  test('themes carry their brightness and the AppTokens extension', () {
    final light = AppTheme.light(textTheme: testTextTheme);
    final dark = AppTheme.dark(textTheme: testTextTheme);
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
    expect(light.extension<AppTokens>(), isNotNull);
    expect(dark.extension<AppTokens>(), isNotNull);
  });
}
