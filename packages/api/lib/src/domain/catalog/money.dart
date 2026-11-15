/// Money is an amount in ZAR cents.
final class Money {
  const Money(this.cents);

  static const zero = Money(0);

  final int cents;

  Money operator +(Money other) => Money(cents + other.cents);

  @override
  bool operator ==(Object other) => other is Money && other.cents == cents;

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => 'Money($cents)';
}
