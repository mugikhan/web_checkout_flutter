import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/mocks.dart';

void main() {
  late MockCatalogRepository repository;

  setUp(() => repository = MockCatalogRepository());

  CatalogBloc build() => CatalogBloc(catalogRepository: repository);

  void answerBags(BagsResult result) =>
      when(() => repository.bags()).thenAnswer((_) async => result);

  const loaded = CatalogState(status: CatalogStatus.loaded, bags: allBags);

  blocTest<CatalogBloc, CatalogState>(
    'a load lists the bags',
    setUp: () => answerBags(const BagsLoaded(allBags)),
    build: build,
    act: (bloc) => bloc.add(const CatalogLoadRequested()),
    expect: () => [const CatalogState(), loaded],
  );

  blocTest<CatalogBloc, CatalogState>(
    'a failed load shows the failure and a retry loads again',
    setUp: () => answerBags(const BagsUnavailable()),
    build: build,
    act: (bloc) async {
      bloc.add(const CatalogLoadRequested());
      await Future<void>.delayed(Duration.zero);
      answerBags(const BagsLoaded(allBags));
      bloc.add(const CatalogLoadRequested());
    },
    expect: () => [
      const CatalogState(),
      const CatalogState(status: CatalogStatus.failed),
      const CatalogState(),
      loaded,
    ],
    verify: (_) => verify(() => repository.bags()).called(2),
  );

  final first = Completer<BagsResult>();
  final second = Completer<BagsResult>();
  blocTest<CatalogBloc, CatalogState>(
    'a new load restarts a running one, so the last result wins',
    setUp: () {
      final answers = [first, second];
      when(() => repository.bags())
          .thenAnswer((_) => answers.removeAt(0).future);
    },
    build: build,
    act: (bloc) async {
      bloc
        ..add(const CatalogLoadRequested())
        ..add(const CatalogLoadRequested());
      await Future<void>.delayed(Duration.zero);
      first.complete(const BagsUnavailable());
      second.complete(const BagsLoaded(allBags));
    },
    expect: () => [const CatalogState(), loaded],
  );

  blocTest<CatalogBloc, CatalogState>(
    'a link before the load is cleaned once the bags arrive',
    setUp: () => answerBags(const BagsLoaded(allBags)),
    build: build,
    act: (bloc) => bloc
      ..add(const CatalogLinkChanged(['bag_cafe', 'bag_bakery']))
      ..add(const CatalogLoadRequested()),
    expect: () => [
      const CatalogState(linkIds: ['bag_cafe', 'bag_bakery']),
      loaded.copyWith(
        linkIds: ['bag_cafe', 'bag_bakery'],
        picked: ['bag_cafe', 'bag_bakery'],
      ),
    ],
    verify: (bloc) {
      expect(bloc.state.needsCleanUrl, isFalse);
      expect(bloc.state.leftOut, isFalse);
      expect(bloc.state.total, const Money(10998));
      expect(bloc.state.canPick('bag_grocery'), isFalse);
      expect(bloc.state.canPick('bag_cafe'), isTrue);
    },
  );

  blocTest<CatalogBloc, CatalogState>(
    'a bad link keeps the first 2 valid ids and sets leftOut',
    build: build,
    seed: () => loaded,
    act: (bloc) => bloc.add(
      const CatalogLinkChanged([
        'bag_unknown',
        'bag_cafe',
        'bag_cafe',
        'bag_bakery',
        'bag_grocery',
      ]),
    ),
    expect: () => [
      loaded.copyWith(
        linkIds: [
          'bag_unknown',
          'bag_cafe',
          'bag_cafe',
          'bag_bakery',
          'bag_grocery',
        ],
        picked: ['bag_cafe', 'bag_bakery'],
        leftOut: true,
      ),
    ],
    verify: (bloc) => expect(bloc.state.needsCleanUrl, isTrue),
  );

  blocTest<CatalogBloc, CatalogState>(
    'the clean URL coming back keeps the notice',
    build: build,
    seed: () => loaded.copyWith(
      linkIds: ['bag_unknown', 'bag_cafe'],
      picked: ['bag_cafe'],
      leftOut: true,
    ),
    act: (bloc) => bloc.add(const CatalogLinkChanged(['bag_cafe'])),
    expect: () => [
      loaded.copyWith(
        linkIds: ['bag_cafe'],
        picked: ['bag_cafe'],
        leftOut: true,
      ),
    ],
    verify: (bloc) => expect(bloc.state.needsCleanUrl, isFalse),
  );

  blocTest<CatalogBloc, CatalogState>(
    'a clean link picks the bags without a notice',
    build: build,
    seed: () => loaded,
    act: (bloc) => bloc.add(const CatalogLinkChanged(['bag_grocery'])),
    expect: () => [
      loaded.copyWith(linkIds: ['bag_grocery'], picked: ['bag_grocery']),
    ],
  );

  blocTest<CatalogBloc, CatalogState>(
    'an empty link clears the picks',
    build: build,
    seed: () => loaded.copyWith(linkIds: ['bag_cafe'], picked: ['bag_cafe']),
    act: (bloc) => bloc.add(const CatalogLinkChanged([])),
    expect: () => [loaded],
    verify: (bloc) => expect(bloc.state.total, Money.zero),
  );

  blocTest<CatalogBloc, CatalogState>(
    'dismissing the notice clears leftOut and keeps the picks',
    build: build,
    seed: () => loaded.copyWith(
      linkIds: ['bag_cafe'],
      picked: ['bag_cafe'],
      leftOut: true,
    ),
    act: (bloc) => bloc.add(const CatalogNoticeDismissed()),
    expect: () => [
      loaded.copyWith(linkIds: ['bag_cafe'], picked: ['bag_cafe']),
    ],
  );

  blocTest<CatalogBloc, CatalogState>(
    'a link while loading waits for the bags',
    build: build,
    act: (bloc) => bloc.add(const CatalogLinkChanged(['bag_unknown'])),
    expect: () => [
      const CatalogState(linkIds: ['bag_unknown']),
    ],
    verify: (bloc) {
      expect(bloc.state.leftOut, isFalse);
      expect(bloc.state.needsCleanUrl, isFalse);
    },
  );
}
