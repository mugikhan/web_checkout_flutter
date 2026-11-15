import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../auth_keys.dart';
import '../session/session_bloc.dart';
import '../session/session_event.dart';
import 'sign_in_bloc.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

/// SignInPage asks for the viewer's name and signs them in.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact =
        WindowSizeClass.fromWidth(MediaQuery.sizeOf(context).width) ==
        WindowSizeClass.compact;

    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (previous, current) =>
          current.status == SignInStatus.succeeded &&
          previous.status != SignInStatus.succeeded,
      listener: (context, state) =>
          context.read<SessionBloc>().add(ViewerSignedIn(state.viewer!)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            key: AuthKeys.signInBack,
            tooltip: 'Back to Bags',
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
          title: const Text('Bag Checkout'),
        ),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(
                  compact ? AppSpacing.lg : AppSpacing.xl,
                ),
                children: [
                  Text('Sign in', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Enter your name to see your account and orders.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SignInForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignInBloc>();
    final state = context.watch<SignInBloc>().state;
    final submitting = state.status != SignInStatus.editing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: AuthKeys.signInName,
          label: 'Name',
          errorText: switch (state.error) {
            SignInError.nameTooShort =>
              'Enter at least ${state.minLength} characters',
            SignInError.unavailable => 'Sign-in failed. Try again.',
            null => null,
          },
          enabled: !submitting,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.name],
          onChanged: (name) => bloc.add(SignInNameChanged(name)),
          onSubmitted: (_) => bloc.add(const SignInSubmitted()),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          key: AuthKeys.signInSubmit,
          label: 'Sign in',
          loading: submitting,
          onPressed: () => bloc.add(const SignInSubmitted()),
        ),
      ],
    );
  }
}
