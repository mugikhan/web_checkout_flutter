import 'package:ui/ui.dart';

/// CatalogKeys holds the test keys for the catalog's widgets.
abstract final class CatalogKeys {
  static Key bag(String id) => ValueKey('catalog-bag-$id');
  static const summaryCount = Key('catalog-summary-count');
  static const summaryTotal = Key('catalog-summary-total');
  static const notice = Key('catalog-notice');
  static const noticeDismiss = Key('catalog-notice-dismiss');
  static const retry = Key('catalog-retry');
}
