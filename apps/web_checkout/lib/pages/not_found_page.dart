import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../app_keys.dart';
import '../router/app_routes.dart';

/// NotFoundPage shows for any URL that matches no route.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StateView.empty(
          icon: Icons.search_off,
          title: 'Page not found',
          message: 'This address does not match any page.',
          actionLabel: 'Go to Bags',
          actionKey: AppKeys.notFoundGoToBags,
          onAction: () => context.go(AppRoutes.bags),
        ),
      ),
    );
  }
}
