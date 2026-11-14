import 'package:material_ui/material_ui.dart';
import 'package:ui/ui.dart';

/// AccountPlaceholderPage holds the Account destination until sign-in arrives.
class AccountPlaceholderPage extends StatelessWidget {
  const AccountPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact =
        WindowSizeClass.fromWidth(MediaQuery.sizeOf(context).width) ==
        WindowSizeClass.compact;

    return ListView(
      padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xl),
      children: [
        Text('Account', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: Text(
            'Sign in to see your orders. Sign-in is not available yet.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
