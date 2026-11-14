import 'package:flutter_test/flutter_test.dart';
import 'package:web_checkout/app.dart';

void main() {
  testWidgets('shows the app title on the home screen', (tester) async {
    await tester.pumpWidget(const BagCheckoutApp());

    expect(find.text('Bag Checkout'), findsOneWidget);
  });
}
