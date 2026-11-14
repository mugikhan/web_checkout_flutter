import '../tokens/app_breakpoints.dart';

/// WindowSizeClass is the Material 3 size class of a window width.
enum WindowSizeClass {
  compact,
  medium,
  expanded;

  factory WindowSizeClass.fromWidth(double width) {
    if (width >= AppBreakpoints.expanded) return WindowSizeClass.expanded;
    if (width >= AppBreakpoints.medium) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }
}
