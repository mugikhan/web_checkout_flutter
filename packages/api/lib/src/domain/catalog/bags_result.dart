import 'package:flutter/foundation.dart';

import 'bag.dart';

/// BagsResult is the outcome of loading the catalog.
sealed class BagsResult {
  const BagsResult();
}

final class BagsLoaded extends BagsResult {
  const BagsLoaded(this.bags);

  final List<Bag> bags;

  @override
  bool operator ==(Object other) =>
      other is BagsLoaded && listEquals(other.bags, bags);

  @override
  int get hashCode => Object.hashAll(bags);
}

/// BagsFailure is an expected reason the catalog did not load.
sealed class BagsFailure extends BagsResult {
  const BagsFailure();
}

/// BagsUnavailable means the request failed for an unexpected reason.
final class BagsUnavailable extends BagsFailure {
  const BagsUnavailable();

  @override
  bool operator ==(Object other) => other is BagsUnavailable;

  @override
  int get hashCode => (BagsUnavailable).hashCode;
}
