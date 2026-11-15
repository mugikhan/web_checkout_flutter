import 'package:api/domain/domain.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui/ui.dart';

import 'support/mocks.dart';

void main() {
  late MockCheckoutRepository repository;
  late List<String> started;
  late int closes;

  setUp(() {
    repository = MockCheckoutRepository();
    started = [];
    closes = 0;
  });

  Future<void> pump(WidgetTester tester, {bool settle = true}) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(textTheme: ThemeData().textTheme),
        home: BlocProvider(
          create: (_) =>
              CheckoutStartBloc(checkoutRepository: repository)
                ..add(const CheckoutStartRequested()),
          child: CheckoutStartPage(
            onStarted: started.add,
            onClose: () => closes++,
          ),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
      await tester.pump();
    }
  }

  testWidgets('hands the new session id to the app once', (tester) async {
    when(() => repository.createSession())
        .thenAnswer((_) async => const CheckoutStarted('cs_1'));

    await pump(tester, settle: false);
    await tester.pump();

    expect(started, ['cs_1']);
  });

  testWidgets('a failure shows the error view, which retries', (tester) async {
    when(() => repository.createSession())
        .thenAnswer((_) async => const CheckoutUnavailable());
    await pump(tester);

    expect(find.text('Checkout could not start'), findsOneWidget);

    when(() => repository.createSession())
        .thenAnswer((_) async => const CheckoutStarted('cs_2'));
    await tester.tap(find.byKey(CheckoutKeys.startRetry));
    await tester.pump();
    await tester.pump();

    expect(started, ['cs_2']);
  });

  testWidgets('close calls back', (tester) async {
    when(() => repository.createSession())
        .thenAnswer((_) async => const CheckoutUnavailable());
    await pump(tester);

    await tester.tap(find.byKey(CheckoutKeys.close));

    expect(closes, 1);
  });
}
