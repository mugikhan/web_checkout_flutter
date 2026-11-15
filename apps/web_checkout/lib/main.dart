import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_it/get_it.dart';
import 'package:ui/ui.dart';

import 'app.dart';
import 'di/configure_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await configureDependencies(GetIt.instance);
  runApp(BagCheckoutApp(sl: GetIt.instance));
}
