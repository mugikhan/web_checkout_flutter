import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';

void main() {
  usePathUrlStrategy();
  runApp(const BagCheckoutApp());
}
