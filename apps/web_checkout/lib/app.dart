import 'dart:async';

import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import 'router/app_router.dart';
import 'router/app_routes.dart';

class BagCheckoutApp extends StatefulWidget {
  const BagCheckoutApp({
    super.key,
    required this.sl,
    this.initialLocation = AppRoutes.bags,
    this.textTheme,
  });

  final GetIt sl;
  final String initialLocation;

  /// Tests pass a plain [textTheme], because google_fonts cannot fetch DM Sans there.
  final TextTheme? textTheme;

  @override
  State<BagCheckoutApp> createState() => _BagCheckoutAppState();
}

class _BagCheckoutAppState extends State<BagCheckoutApp> {
  late final SessionBloc _session = widget.sl<SessionBloc>()
    ..add(const SessionCheckRequested());
  late final GoRouter _router = buildRouter(
    sl: widget.sl,
    session: _session,
    initialLocation: widget.initialLocation,
  );
  late final StreamSubscription<SessionState> _sessionChanges;

  @override
  void initState() {
    super.initState();
    _sessionChanges = _session.stream.listen(_onSessionChanged);
  }

  // A refresh redirect reports a new browser entry; on sign-in, replace the sign-in entry.
  void _onSessionChanged(SessionState state) {
    final context = _router.routerDelegate.navigatorKey.currentContext;
    if (state is SessionSignedIn && context != null) {
      Router.neglect(context, _router.refresh);
    } else {
      _router.refresh();
    }
  }

  @override
  void dispose() {
    _sessionChanges.cancel();
    _router.dispose();
    _session.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _session,
      child: MaterialApp.router(
        title: 'Bag Checkout',
        theme: AppTheme.light(textTheme: widget.textTheme),
        darkTheme: AppTheme.dark(textTheme: widget.textTheme),
        themeMode: ThemeMode.system,
        routerConfig: _router,
        // Hold every page until the stored session is known, so guards never flash.
        builder: (context, child) => BlocBuilder<SessionBloc, SessionState>(
          buildWhen: (previous, current) => previous is SessionChecking,
          builder: (context, state) => state is SessionChecking
              ? const Scaffold(body: StateView.loading(title: 'Loading'))
              : child!,
        ),
      ),
    );
  }
}
