import 'package:material_ui/material_ui.dart';

import '../layout/window_size_class.dart';
import '../tokens/app_spacing.dart';

/// AdaptiveDestination is one top-level destination in [AdaptiveScaffold].
class AdaptiveDestination {
  const AdaptiveDestination({
    required this.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Key key;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// AdaptiveScaffold shows a bottom bar, a rail or an extended rail by window width.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.title,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  final String title;
  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final sizeClass = WindowSizeClass.fromWidth(
      MediaQuery.sizeOf(context).width,
    );

    if (sizeClass == WindowSizeClass.compact) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            for (final d in destinations)
              NavigationDestination(
                key: d.key,
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    final extended = sizeClass == WindowSizeClass.expanded;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: extended,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              leading: extended
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xl,
                      ),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  : null,
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    // NavigationRailDestination takes no key, so key its icons.
                    icon: KeyedSubtree(key: d.key, child: Icon(d.icon)),
                    selectedIcon: KeyedSubtree(
                      key: d.key,
                      child: Icon(d.selectedIcon),
                    ),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
