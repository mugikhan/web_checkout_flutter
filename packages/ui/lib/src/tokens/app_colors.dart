import 'package:material_ui/material_ui.dart';

/// AppColors holds one theme's colour roles, as listed in DESIGN.md.
class AppColors {
  const AppColors({
    required this.surface,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.outline,
    required this.outlineVariant,
    required this.brandLime,
    required this.onBrandLime,
    required this.brandSage,
    required this.brandOrange,
  });

  static const light = AppColors(
    surface: Color(0xFFF6F3EE),
    surfaceContainer: Color(0xFFF6F3EE),
    onSurface: Color(0xFF1D2B24),
    onSurfaceVariant: Color(0xFF5C7066),
    primary: Color(0xFF1D2B24),
    onPrimary: Color(0xFFE7F54D),
    secondary: Color(0xFFBCCBCD),
    onSecondary: Color(0xFF1D2B24),
    tertiary: Color(0xFFE7F54D),
    onTertiary: Color(0xFF1D2B24),
    error: Color(0xFFAD4800),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFF791A),
    onErrorContainer: Color(0xFF1D2B24),
    outline: Color(0xFFC7D1CC),
    outlineVariant: Color(0xFFC7D1CC),
    brandLime: Color(0xFFE7F54D),
    onBrandLime: Color(0xFF1D2B24),
    brandSage: Color(0xFFBCCBCD),
    brandOrange: Color(0xFFFF791A),
  );

  static const dark = AppColors(
    surface: Color(0xFF101814),
    surfaceContainer: Color(0xFF18251F),
    onSurface: Color(0xFFF6F3EE),
    onSurfaceVariant: Color(0xFF9DADAF),
    primary: Color(0xFFE7F54D),
    onPrimary: Color(0xFF1D2B24),
    secondary: Color(0xFF2B3B33),
    onSecondary: Color(0xFFF6F3EE),
    tertiary: Color(0xFFFF791A),
    onTertiary: Color(0xFF1D2B24),
    error: Color(0xFFDE6E6E),
    onError: Color(0xFF1D2B24),
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFAFAFA),
    outline: Color(0xFF2B3B33),
    outlineVariant: Color(0xFF2B3B33),
    brandLime: Color(0xFFE7F54D),
    onBrandLime: Color(0xFF1D2B24),
    brandSage: Color(0xFFBCCBCD),
    brandOrange: Color(0xFFFF791A),
  );

  final Color surface;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color outline;
  final Color outlineVariant;
  final Color brandLime;
  final Color onBrandLime;
  final Color brandSage;
  final Color brandOrange;

  /// byRole maps each DESIGN.md role name to its colour.
  Map<String, Color> get byRole => {
    'surface': surface,
    'surfaceContainer': surfaceContainer,
    'onSurface': onSurface,
    'onSurfaceVariant': onSurfaceVariant,
    'primary': primary,
    'onPrimary': onPrimary,
    'secondary': secondary,
    'onSecondary': onSecondary,
    'tertiary': tertiary,
    'onTertiary': onTertiary,
    'error': error,
    'onError': onError,
    'errorContainer': errorContainer,
    'onErrorContainer': onErrorContainer,
    'outline': outline,
    'outlineVariant': outlineVariant,
    'brandLime': brandLime,
    'onBrandLime': onBrandLime,
    'brandSage': brandSage,
    'brandOrange': brandOrange,
  };
}
