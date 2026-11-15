import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../auth_keys.dart';
import '../session/session_bloc.dart';
import '../session/session_event.dart';
import '../session/session_state.dart';

/// AccountPage shows the signed-in viewer and the Sign out action.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key, required this.onSignOut});

  /// onSignOut runs right after the sign-out request, so the app can navigate.
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact =
        WindowSizeClass.fromWidth(MediaQuery.sizeOf(context).width) ==
        WindowSizeClass.compact;
    final name = switch (context.watch<SessionBloc>().state) {
      SessionSignedIn(:final viewer) => viewer.name,
      SessionChecking() || SessionSignedOut() => '',
    };

    return ListView(
      padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xl),
      children: [
        Text('Account', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Signed in as',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(name, style: theme.textTheme.titleLarge),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(
            key: AuthKeys.signOut,
            label: 'Sign out',
            variant: AppButtonVariant.secondary,
            onPressed: () {
              context.read<SessionBloc>().add(const SignOutRequested());
              onSignOut();
            },
          ),
        ),
      ],
    );
  }
}
