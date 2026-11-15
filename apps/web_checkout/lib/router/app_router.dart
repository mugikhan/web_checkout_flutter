import 'package:auth/auth.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../pages/not_found_page.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';
import 'auth_redirect.dart';

/// buildRouter builds the app's routes and guards them with [session].
GoRouter buildRouter({
  required GetIt sl,
  required SessionBloc session,
  required Listenable refresh,
  String initialLocation = AppRoutes.bags,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: refresh,
    redirect: (context, state) => authRedirect(session.state, state.uri),
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SignInBloc>(),
          child: SignInPage(onBack: () => context.go(AppRoutes.bags)),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bags,
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      sl<CatalogBloc>()..add(const CatalogLoadRequested()),
                  child: CatalogPage(
                    bagIds: AppRoutes.bagIdsFrom(state.uri),
                    // Neglect replaces the browser entry; go_router's replace still adds one.
                    onSelectionChanged: (ids) => Router.neglect(
                      context,
                      () => context.go(AppRoutes.bagsLocation(ids)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) =>
                    AccountPage(onSignOut: () => context.go(AppRoutes.bags)),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
