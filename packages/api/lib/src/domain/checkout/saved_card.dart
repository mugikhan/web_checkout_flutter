/// SavedCard is a seeded payment method, shown masked.
final class SavedCard {
  const SavedCard({required this.id, required this.brand, required this.last4});

  final String id;
  final String brand;
  final String last4;

  @override
  bool operator ==(Object other) =>
      other is SavedCard &&
      other.id == id &&
      other.brand == brand &&
      other.last4 == last4;

  @override
  int get hashCode => Object.hash(id, brand, last4);

  @override
  String toString() => 'SavedCard($id)';
}
