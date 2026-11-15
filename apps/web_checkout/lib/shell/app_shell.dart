import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../app_keys.dart';

/// AppShell wraps the shell branches in the adaptive navigation.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Bag Checkout',
      selectedIndex: navigationShell.currentIndex,
      // Tapping the current destination again returns it to its first page.
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      destinations: const [
        AdaptiveDestination(
          key: AppKeys.navBags,
          icon: Icons.shopping_bag_outlined,
          selectedIcon: Icons.shopping_bag,
          label: 'Bags',
        ),
        AdaptiveDestination(
          key: AppKeys.navAccount,
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Account',
        ),
      ],
      body: navigationShell,
    );
  }
}
