import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

void main() {
  test('registers AppStorage', () async {
    SharedPreferences.setMockInitialValues({});
    final sl = GetIt.asNewInstance();

    await registerStorage(sl);

    expect(sl<AppStorage>(), isA<AppStorage>());
  });
}
