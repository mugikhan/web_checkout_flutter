import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a name needs more than 3 characters after trimming', () {
    expect(ViewerName.isValid('Bob'), isFalse);
    expect(ViewerName.isValid('  Bob  '), isFalse);
    expect(ViewerName.isValid('    '), isFalse);
    expect(ViewerName.isValid('Thab'), isTrue);
    expect(ViewerName.isValid(' Thab '), isTrue);
  });
}
