import 'package:material_ui/material_ui.dart';

/// AppTokens carries the brand colours that ColorScheme has no role for.
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.brandLime,
    required this.onBrandLime,
    required this.brandSage,
    required this.brandOrange,
  });

  final Color brandLime;
  final Color onBrandLime;
  final Color brandSage;
  final Color brandOrange;

  @override
  AppTokens copyWith({
    Color? brandLime,
    Color? onBrandLime,
    Color? brandSage,
    Color? brandOrange,
  }) {
    return AppTokens(
      brandLime: brandLime ?? this.brandLime,
      onBrandLime: onBrandLime ?? this.onBrandLime,
      brandSage: brandSage ?? this.brandSage,
      brandOrange: brandOrange ?? this.brandOrange,
    );
  }

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    return AppTokens(
      brandLime: Color.lerp(brandLime, other.brandLime, t)!,
      onBrandLime: Color.lerp(onBrandLime, other.onBrandLime, t)!,
      brandSage: Color.lerp(brandSage, other.brandSage, t)!,
      brandOrange: Color.lerp(brandOrange, other.brandOrange, t)!,
    );
  }
}

/// AppTokensContext reads [AppTokens] from the nearest theme.
extension AppTokensContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}
