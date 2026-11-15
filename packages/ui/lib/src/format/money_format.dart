import 'package:intl/intl.dart';

final _zar = NumberFormat.simpleCurrency(locale: 'en_ZA');

/// formatZar formats ZAR [cents] for en_ZA, such as "R59,99".
String formatZar(int cents) => _zar.format(cents / 100);
