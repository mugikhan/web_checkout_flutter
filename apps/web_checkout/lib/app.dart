import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui/ui.dart';

import 'router/app_router.dart';
import 'router/app_routes.dart';

class BagCheckoutApp extends StatefulWidget {
  const BagCheckoutApp({
    super.key,
    this.initialLocation = AppRoutes.bags,
    this.textTheme,
  });

  final String initialLocation;

  /// Tests pass a plain [textTheme], because google_fonts cannot fetch DM Sans there.
  final TextTheme? textTheme;

  @override
  State<BagCheckoutApp> createState() => _BagCheckoutAppState();
}

class _BagCheckoutAppState extends State<BagCheckoutApp> {
  late final GoRouter _router = buildRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bag Checkout',
      theme: AppTheme.light(textTheme: widget.textTheme),
      darkTheme: AppTheme.dark(textTheme: widget.textTheme),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
