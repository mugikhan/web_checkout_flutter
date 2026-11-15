import 'package:material_ui/material_ui.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// InlineNotice shows a short, dismissible message that screen readers announce.
class InlineNotice extends StatelessWidget {
  const InlineNotice({
    super.key,
    required this.message,
    required this.onDismiss,
    this.dismissKey,
    this.icon = Icons.info_outline,
  });

  final String message;
  final VoidCallback onDismiss;
  final Key? dismissKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      container: true,
      liveRegion: true,
      child: Material(
        color: scheme.secondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.xs,
            bottom: AppSpacing.xs,
            right: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(icon, color: scheme.onSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSecondary,
                  ),
                ),
              ),
              IconButton(
                key: dismissKey,
                tooltip: 'Dismiss',
                icon: const Icon(Icons.close),
                color: scheme.onSecondary,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
