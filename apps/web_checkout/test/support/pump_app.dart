import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_checkout/app.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const naledi = Viewer(id: 'viewer:naledi', name: 'Naledi');

/// mockAuthRepository stubs a repository that starts with [viewer] signed in.
MockAuthRepository mockAuthRepository({Viewer? viewer}) {
  final repository = MockAuthRepository();
  when(() => repository.currentViewer()).thenAnswer((_) async => viewer);
  when(() => repository.signIn(any()))
      .thenAnswer((_) async => const SignedIn(naledi));
  when(() => repository.signOut()).thenAnswer((_) async {});
  return repository;
}

/// pumpApp starts the app at [location]; pass `settle: false` while a spinner shows.
Future<void> pumpApp(
  WidgetTester tester, {
  String location = '/',
  Size size = const Size(400, 800),
  AuthRepository? repository,
  bool settle = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final sl = GetIt.asNewInstance()
    ..registerSingleton<AuthRepository>(repository ?? mockAuthRepository());
  registerAuthModule(sl);

  await tester.pumpWidget(
    BagCheckoutApp(
      sl: sl,
      initialLocation: location,
      textTheme: ThemeData().textTheme,
    ),
  );
  if (settle) await tester.pumpAndSettle();
}

/// currentLocation reads the router's current URI.
String currentLocation(WidgetTester tester) {
  final context = tester.element(find.byType(Navigator).first);
  return GoRouter.of(context).routerDelegate.currentConfiguration.uri
      .toString();
}
