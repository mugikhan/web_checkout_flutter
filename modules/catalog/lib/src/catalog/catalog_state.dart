import 'package:api/domain/domain.dart';
import 'package:flutter/foundation.dart';

enum CatalogStatus { loading, loaded, failed }

/// CatalogState holds the bags, the ids in the URL and the clean picks.
class CatalogState {
  const CatalogState({
    this.status = CatalogStatus.loading,
    this.bags = const [],
    this.linkIds = const [],
    this.picked = const [],
    this.leftOut = false,
  });

  final CatalogStatus status;
  final List<Bag> bags;

  /// The bag ids the URL holds, before cleaning.
  final List<String> linkIds;

  /// The clean bag ids, in pick order, once [status] is loaded.
  final List<String> picked;

  /// Whether a bad link lost some bags, until the user dismisses the notice.
  final bool leftOut;

  List<Bag> get pickedBags => [
    for (final id in picked) bags.firstWhere((bag) => bag.id == id),
  ];

  Money get total => pickedBags.fold(Money.zero, (sum, bag) => sum + bag.price);

  bool canPick(String id) => BagSelection.canPick(picked, id);

  /// needsCleanUrl is true when the URL holds ids the catalog dropped.
  bool get needsCleanUrl =>
      status == CatalogStatus.loaded && !listEquals(linkIds, picked);

  CatalogState copyWith({
    CatalogStatus? status,
    List<Bag>? bags,
    List<String>? linkIds,
    List<String>? picked,
    bool? leftOut,
  }) => CatalogState(
    status: status ?? this.status,
    bags: bags ?? this.bags,
    linkIds: linkIds ?? this.linkIds,
    picked: picked ?? this.picked,
    leftOut: leftOut ?? this.leftOut,
  );

  @override
  bool operator ==(Object other) =>
      other is CatalogState &&
      other.status == status &&
      listEquals(other.bags, bags) &&
      listEquals(other.linkIds, linkIds) &&
      listEquals(other.picked, picked) &&
      other.leftOut == leftOut;

  @override
  int get hashCode => Object.hash(
    status,
    Object.hashAll(bags),
    Object.hashAll(linkIds),
    Object.hashAll(picked),
    leftOut,
  );

  @override
  String toString() =>
      'CatalogState(${status.name}, ${bags.length} bags, link $linkIds, '
      'picked $picked, leftOut $leftOut)';
}
