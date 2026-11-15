import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('writes, reads and deletes a value', () async {
    final storage = await AppStorage.sharedPreferences();

    await storage.client.write('token', 'abc');
    expect(await storage.client.read('token'), 'abc');

    await storage.client.delete('token');
    expect(await storage.client.read('token'), isNull);
  });

  test('keeps the client and server namespaces apart', () async {
    final storage = await AppStorage.sharedPreferences();

    await storage.client.write('key', 'client value');
    await storage.server.write('key', 'server value');

    expect(await storage.client.read('key'), 'client value');
    expect(await storage.server.read('key'), 'server value');

    await storage.client.delete('key');
    expect(await storage.server.read('key'), 'server value');
  });

  test('prefixes keys with the namespace', () async {
    final storage = await AppStorage.sharedPreferences();
    await storage.server.write('sessions', '{}');

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('server.sessions'), '{}');
  });

  test('a new store reads values an earlier one wrote', () async {
    SharedPreferences.setMockInitialValues({'client.token': 'saved'});

    final storage = await AppStorage.sharedPreferences();

    expect(await storage.client.read('token'), 'saved');
  });
}
