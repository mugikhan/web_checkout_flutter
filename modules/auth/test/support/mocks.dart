import 'package:api/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const naledi = Viewer(id: 'viewer:naledi', name: 'Naledi');
