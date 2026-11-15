sealed class CatalogEvent {
  const CatalogEvent();
}

final class CatalogLoadRequested extends CatalogEvent {
  const CatalogLoadRequested();
}

/// CatalogLinkChanged carries the bag ids the URL holds now, as written.
final class CatalogLinkChanged extends CatalogEvent {
  const CatalogLinkChanged(this.ids);

  final List<String> ids;
}

final class CatalogNoticeDismissed extends CatalogEvent {
  const CatalogNoticeDismissed();
}
