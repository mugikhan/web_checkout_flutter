import 'package:material_ui/material_ui.dart';

import '../tokens/app_spacing.dart';

/// AppCard groups related content on a flat, outlined surface.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );
  }
}
