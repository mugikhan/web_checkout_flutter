import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import 'app_tokens.dart';

/// AppTheme builds the light and dark themes described in DESIGN.md.
abstract final class AppTheme {
  /// Pass [textTheme] in tests, where google_fonts cannot fetch DM Sans.
  static ThemeData light({TextTheme? textTheme}) =>
      _build(AppColors.light, Brightness.light, textTheme);

  static ThemeData dark({TextTheme? textTheme}) =>
      _build(AppColors.dark, Brightness.dark, textTheme);

  static ColorScheme colorScheme(AppColors c, Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.secondary,
      onSecondary: c.onSecondary,
      tertiary: c.tertiary,
      onTertiary: c.onTertiary,
      error: c.error,
      onError: c.onError,
      errorContainer: c.errorContainer,
      onErrorContainer: c.onErrorContainer,
      surface: c.surface,
      onSurface: c.onSurface,
      surfaceContainer: c.surfaceContainer,
      onSurfaceVariant: c.onSurfaceVariant,
      outline: c.outline,
      outlineVariant: c.outlineVariant,
    );
  }

  static ThemeData _build(
    AppColors c,
    Brightness brightness,
    TextTheme? textTheme,
  ) {
    final scheme = colorScheme(c, brightness);
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final scaled = _scale(textTheme ?? base.textTheme);
    final text = textTheme == null
        ? GoogleFonts.dmSansTextTheme(scaled)
        : scaled;
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    OutlineInputBorder field(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );

    return base.copyWith(
      scaffoldBackgroundColor: c.surface,
      textTheme: text,
      extensions: [
        AppTokens(
          brandLime: c.brandLime,
          onBrandLime: c.onBrandLime,
          brandSage: c.brandSage,
          brandOrange: c.brandOrange,
        ),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: text.titleLarge?.copyWith(color: c.onSurface),
      ),
      cardTheme: CardThemeData(
        color: c.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: rounded.copyWith(side: BorderSide(color: c.outline)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        elevation: 0,
        indicatorColor: c.brandLime,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? c.onBrandLime
                : c.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          text.labelMedium?.copyWith(color: c.onSurface),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: c.surface,
        elevation: 0,
        indicatorColor: c.brandLime,
        selectedIconTheme: IconThemeData(color: c.onBrandLime),
        unselectedIconTheme: IconThemeData(color: c.onSurfaceVariant),
        selectedLabelTextStyle: text.labelMedium?.copyWith(color: c.onSurface),
        unselectedLabelTextStyle: text.labelMedium?.copyWith(
          color: c.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(color: c.outline, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: text.bodyLarge?.copyWith(color: c.onSurfaceVariant),
        errorStyle: text.bodyMedium?.copyWith(color: c.error),
        border: field(c.onSurfaceVariant, 1),
        enabledBorder: field(c.onSurfaceVariant, 1),
        focusedBorder: field(c.primary, 2),
        errorBorder: field(c.error, 1),
        focusedErrorBorder: field(c.error, 2),
      ),
    );
  }

  static TextTheme _scale(TextTheme t) {
    TextStyle? style(TextStyle? s, double size, double height, FontWeight w) =>
        s?.copyWith(fontSize: size, height: height / size, fontWeight: w);

    return t.copyWith(
      displaySmall: style(t.displaySmall, 36, 44, FontWeight.w600),
      headlineMedium: style(t.headlineMedium, 28, 36, FontWeight.w600),
      titleLarge: style(t.titleLarge, 22, 28, FontWeight.w600),
      titleMedium: style(t.titleMedium, 16, 24, FontWeight.w600),
      bodyLarge: style(t.bodyLarge, 16, 24, FontWeight.w400),
      bodyMedium: style(t.bodyMedium, 14, 20, FontWeight.w400),
      labelLarge: style(t.labelLarge, 14, 20, FontWeight.w600),
      labelMedium: style(t.labelMedium, 12, 16, FontWeight.w500),
    );
  }
}
