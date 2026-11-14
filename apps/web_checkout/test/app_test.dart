import 'package:flutter_test/flutter_test.dart';

import 'support/pump_app.dart';

void main() {
  testWidgets('shows the app title on launch', (tester) async {
    await pumpApp(tester);

    expect(find.text('Bag Checkout'), findsOneWidget);
  });
}
