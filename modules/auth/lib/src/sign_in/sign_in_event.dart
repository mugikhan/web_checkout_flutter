sealed class SignInEvent {
  const SignInEvent();
}

final class SignInNameChanged extends SignInEvent {
  const SignInNameChanged(this.name);

  final String name;
}

final class SignInSubmitted extends SignInEvent {
  const SignInSubmitted();
}
