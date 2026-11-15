import 'money.dart';
import 'store.dart';

/// Bag is a surplus-food bag the customer can pick, priced below its worth.
final class Bag {
  const Bag({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.worth,
    required this.store,
  });

  final String id;
  final String name;
  final String description;
  final Money price;
  final Money worth;
  final Store store;

  @override
  bool operator ==(Object other) =>
      other is Bag &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.price == price &&
      other.worth == worth &&
      other.store == store;

  @override
  int get hashCode => Object.hash(id, name, description, price, worth, store);

  @override
  String toString() => 'Bag($id)';
}
