import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/pump_app.dart';

void main() {
  testWidgets('shows the app title on launch', (tester) async {
    await pumpApp(tester);

    expect(find.text('Bag Checkout'), findsOneWidget);
  });

  testWidgets('shows a loading view until the session is known', (
    tester,
  ) async {
    final check = Completer<Viewer?>();
    final repository = mockAuthRepository();
    when(() => repository.currentViewer()).thenAnswer((_) => check.future);

    await pumpApp(
      tester,
      location: '/account',
      repository: repository,
      settle: false,
    );
    await tester.pump();
    expect(find.text('Loading'), findsOneWidget);
    expect(find.text('Sign in'), findsNothing);

    check.complete(naledi);
    await tester.pumpAndSettle();
    expect(find.text('Naledi'), findsOneWidget);
  });
}
