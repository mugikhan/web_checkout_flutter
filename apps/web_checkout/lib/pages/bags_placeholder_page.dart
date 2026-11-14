import 'package:material_ui/material_ui.dart';
import 'package:ui/ui.dart';

/// BagsPlaceholderPage holds the Bags destination until the catalog arrives.
class BagsPlaceholderPage extends StatelessWidget {
  const BagsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StateView.empty(
      icon: Icons.shopping_bag_outlined,
      title: 'Bags',
      message: 'Surplus bags from Corner Pantry will show here.',
    );
  }
}
