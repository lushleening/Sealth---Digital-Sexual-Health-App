import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/encryption.dart';
import 'package:test/test.dart';

import '../../helper/mock_objects.dart';

void main() {
  late MockSecureStorage mockStorage;
  setUp(() {
    mockStorage = MockSecureStorage();

    when(
      () => mockStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => null);

    when(
      () => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async => Future.value());
  });

  test('Returns existing key when it is already in storage', () async {
    const existingKey = 'existingKey';
    when(
      () => mockStorage.read(key: dbKeyName),
    ).thenAnswer((_) async => existingKey);

    final result = await getOrInsertEncryptionKey(storage: mockStorage);

    expect(result, existingKey);
    verifyNever(
      () => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    );
  });

  test('Generate and save a new key if storage is empty', () async {
    when(() => mockStorage.read(key: dbKeyName)).thenAnswer((_) async => null);

    when(
      () => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async => {});

    final result = await getOrInsertEncryptionKey(storage: mockStorage);

    expect(result, isNotNull);
    verify(() => mockStorage.write(key: dbKeyName, value: result)).called(1);
  });
}
