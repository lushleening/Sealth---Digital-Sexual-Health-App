import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/storage/supabase/supabase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helper/mock_objects.dart';

void main() {
  late MockSupabaseClient mockClient;
  late MockSupabaseStorageClient mockStorage;
  late MockStorageFileApi mockFileApi;
  late MockFile mockFile;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockStorage = MockSupabaseStorageClient();
    mockFileApi = MockStorageFileApi();
    mockFile = MockFile();

    when(() => mockClient.storage).thenReturn(mockStorage);
    when(() => mockStorage.from(any())).thenReturn(mockFileApi);
    when(() => mockFile.path).thenReturn('test_avatar.png');

    registerFallbackValue(File(''));
    registerFallbackValue(FileOptions());
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('uploadAvatar returns public URL on success', () async {
    const fakeUrl =
        'https://supabase.com/storage/v1/public/avatars/$remoteId.png';
    when(
      () => mockFileApi.upload(
        any(),
        any(),
        fileOptions: any(named: 'fileOptions'),
      ),
    ).thenAnswer((_) async => 'path/to/file');
    when(() => mockFileApi.getPublicUrl(any())).thenReturn(fakeUrl);
    final result = await uploadAvatar(mockClient, mockFile, remoteId);
    expect(result, contains(fakeUrl));
    verify(() => mockStorage.from('avatars')).called(greaterThan(0));
  });

  test('uploadAvatar returns null on failure', () async {
    when(
      () => mockFileApi.upload(
        any(),
        any(),
        fileOptions: any(named: 'fileOptions'),
      ),
    ).thenThrow(StorageException('Upload failed'));
    final result = await uploadAvatar(mockClient, mockFile, remoteId);
    expect(result, isNull);
  });
}
