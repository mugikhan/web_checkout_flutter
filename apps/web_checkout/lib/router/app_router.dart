import 'package:auth/auth.dart';
import 'package:catalog/catalog.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/orders.dart';
import 'package:ui/ui.dart';

import '../pages/not_found_page.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';
import 'auth_redirect.dart';

/// buildRouter builds the app's routes and guards them with [session].
GoRouter buildRouter({
  required GetIt sl,
  required SessionBloc session,
  String initialLocation = AppRoutes.bags,
}) {
  // Neglect replaces the browser entry; go_router's replace still adds one.
  void replace(BuildContext context, String location) =>
      Router.neglect(context, () => context.go(location));

  return GoRouter(
    initialLocation: initialLocation,
    redirect: (context, state) => authRedirect(session.state, state.uri),
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SignInBloc>(),
          child: SignInPage(onBack: () => context.go(AppRoutes.bags)),
        ),
      ),
      GoRoute(
        path: AppRoutes.checkoutNew,
        redirect: (context, state) =>
            AppRoutes.bagIdsFrom(state.uri).isEmpty ? AppRoutes.bags : null,
        builder: (context, state) {
          final bagIds = AppRoutes.bagIdsFrom(state.uri);
          final slot = AppRoutes.slotFrom(state.uri);
          return BlocProvider(
            create: (_) =>
                sl<CheckoutStartBloc>()..add(const CheckoutStartRequested()),
            child: CheckoutStartPage(
              onStarted: (sessionId) => replace(
                context,
                AppRoutes.checkoutLocation(sessionId, bagIds, slot: slot),
              ),
              onClose: () => context.go(AppRoutes.bagsLocation(bagIds)),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return BlocProvider(
            create: (_) =>
                sl<CheckoutBloc>()..add(CheckoutLoadRequested(sessionId)),
            child: CheckoutPage(
              bagIds: AppRoutes.bagIdsFrom(state.uri),
              slot: AppRoutes.slotFrom(state.uri),
              onDraftChanged: (bagIds, slot) => replace(
                context,
                AppRoutes.checkoutLocation(sessionId, bagIds, slot: slot),
              ),
              onClose: (bagIds) => context.go(AppRoutes.bagsLocation(bagIds)),
              onStartAgain: (bagIds, slot) => bagIds.isEmpty
                  ? context.go(AppRoutes.bags)
                  : replace(
                      context,
                      AppRoutes.checkoutStart(bagIds, slot: slot),
                    ),
              onCompleted: (orderId) =>
                  replace(context, AppRoutes.orderLocation(orderId)),
            ),
          );
        },
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
                    onSelectionChanged: (ids) =>
                        replace(context, AppRoutes.bagsLocation(ids)),
                    onContinue: (ids) =>
                        context.go(AppRoutes.checkoutStart(ids)),
                  ),
                ),
              ),
              GoRoute(
                path: AppRoutes.order,
                builder: (context, state) {
                  final orderId = state.pathParameters['orderId']!;
                  return BlocProvider(
                    key: ValueKey(orderId),
                    create: (_) =>
                        sl<OrderBloc>()..add(OrderLoadRequested(orderId)),
                    child: OrderPage(
                      onBackToBags: () => context.go(AppRoutes.bags),
                    ),
                  );
                },
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
