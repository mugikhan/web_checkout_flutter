import 'package:api/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'catalog_event.dart';
import 'catalog_state.dart';

/// CatalogBloc loads the bags and cleans the picks the URL holds.
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({required this._catalogRepository})
    : super(const CatalogState()) {
    on<CatalogLoadRequested>(_onLoadRequested, transformer: restartable());
    on<CatalogLinkChanged>(
      (event, emit) => emit(_withLink(state.copyWith(linkIds: event.ids))),
    );
    on<CatalogNoticeDismissed>(
      (event, emit) => emit(state.copyWith(leftOut: false)),
    );
  }

  final CatalogRepository _catalogRepository;

  Future<void> _onLoadRequested(
    CatalogLoadRequested event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: CatalogStatus.loading));
    final result = await _catalogRepository.bags();
    emit(switch (result) {
      BagsLoaded(:final bags) => _withLink(
        state.copyWith(status: CatalogStatus.loaded, bags: bags),
      ),
      BagsUnavailable() => state.copyWith(status: CatalogStatus.failed),
    });
  }

  static CatalogState _withLink(CatalogState state) {
    if (state.status != CatalogStatus.loaded) return state;
    final known = {for (final bag in state.bags) bag.id};
    final picked = BagSelection.clean(state.linkIds, known);
    final cleaned = picked.length != state.linkIds.length;
    return state.copyWith(picked: picked, leftOut: state.leftOut || cleaned);
  }
}
