import 'package:material_ui/material_ui.dart';

import '../tokens/app_spacing.dart';
import 'app_button.dart';

/// StateView shows an empty, error or loading state with an optional action.
class StateView extends StatelessWidget {
  const StateView.empty({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  }) : _isError = false,
       _isLoading = false;

  /// StateView.error requires an action, so the user is never stuck.
  const StateView.error({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.error_outline,
    required String this.actionLabel,
    required VoidCallback this.onAction,
    this.actionKey,
  }) : _isError = true,
       _isLoading = false;

  const StateView.loading({super.key, required this.title})
    : message = null,
      icon = null,
      actionLabel = null,
      onAction = null,
      actionKey = null,
      _isError = false,
      _isLoading = true;

  final String title;
  final String? message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;
  final bool _isError;
  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else if (icon != null)
                Icon(
                  icon,
                  size: 48,
                  color: _isError ? scheme.error : scheme.onSurfaceVariant,
                ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  key: actionKey,
                  label: actionLabel!,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
