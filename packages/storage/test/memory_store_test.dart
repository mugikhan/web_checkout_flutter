import 'package:flutter_test/flutter_test.dart';
import 'package:storage/storage.dart';

void main() {
  test('writes, reads and deletes a value', () async {
    final store = MemoryStore({'seed': '1'});
    expect(await store.read('seed'), '1');

    await store.write('token', 'abc');
    expect(await store.read('token'), 'abc');

    await store.delete('token');
    expect(await store.read('token'), isNull);
  });
}
