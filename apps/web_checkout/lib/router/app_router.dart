import 'package:go_router/go_router.dart';

import '../pages/account_placeholder_page.dart';
import '../pages/bags_placeholder_page.dart';
import '../pages/not_found_page.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

/// buildRouter builds the app's routes; tests pass [initialLocation].
GoRouter buildRouter({String initialLocation = AppRoutes.bags}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bags,
                builder: (context, state) => const BagsPlaceholderPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) => const AccountPlaceholderPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
