import 'package:material_ui/material_ui.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

enum InlineNoticeTone { info, error }

/// InlineNotice shows a short, dismissible message that screen readers announce.
class InlineNotice extends StatelessWidget {
  const InlineNotice({
    super.key,
    required this.message,
    required this.onDismiss,
    this.dismissKey,
    this.icon = Icons.info_outline,
    this.tone = InlineNoticeTone.info,
  });

  final String message;
  final VoidCallback onDismiss;
  final Key? dismissKey;
  final IconData icon;
  final InlineNoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (background, foreground) = switch (tone) {
      InlineNoticeTone.info => (scheme.secondary, scheme.onSecondary),
      InlineNoticeTone.error => (
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
    };

    return Semantics(
      container: true,
      liveRegion: true,
      child: Material(
        color: background,
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
              Icon(icon, color: foreground),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                  ),
                ),
              ),
              IconButton(
                key: dismissKey,
                tooltip: 'Dismiss',
                icon: const Icon(Icons.close),
                color: foreground,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
