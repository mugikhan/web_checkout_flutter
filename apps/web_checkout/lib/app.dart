import 'package:material_ui/material_ui.dart';

class BagCheckoutApp extends StatelessWidget {
  const BagCheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bag Checkout',
      home: _HomePlaceholderPage(),
    );
  }
}

class _HomePlaceholderPage extends StatelessWidget {
  const _HomePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bag Checkout',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
