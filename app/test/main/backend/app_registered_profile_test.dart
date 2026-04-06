import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

import '../../helper/mock_objects.dart';

class MockProfilesRepository extends Mock implements ProfilesRepository {}

void main() {
  late ProviderContainer container;
  late MockProfilesRepository mockRepo;

  setUp(() {
    mockRepo = MockProfilesRepository();
    container = ProviderContainer.test(
      overrides: [
        profilesRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
      ],
    );
    registerFallbackValue(testAppRegisteredProfile);
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Build returns profile when remoteId and profile exist', () async {
    when(
      () => mockRepo.getProfile(remoteId),
    ).thenAnswer((_) async => testAppRegisteredProfile);
    final result = await container.read(appRegisteredProfileProvider.future);
    expect(result, testAppRegisteredProfile);
    verify(() => mockRepo.getProfile(remoteId)).called(1);
  });

  test('Build throws StateError when profile is null', () async {
    when(() => mockRepo.getProfile(remoteId)).thenAnswer((_) async => null);
    expect(
      () => container.read(appRegisteredProfileProvider.future),
      throwsA(isA<StateError>()),
    );
  });

  test('updateProfile reloads state on success', () async {
    when(
      () => mockRepo.getProfile(remoteId),
    ).thenAnswer((_) async => testAppRegisteredProfile);
    when(
      () => mockRepo.upsertProfileRemote(
        any(),
        any(),
        checkForConflicts: any(named: 'checkForConflicts'),
      ),
    ).thenAnswer((_) async => true);

    final notifier = container.read(appRegisteredProfileProvider.notifier);
    await notifier.updateProfile(remoteId, testAppRegisteredProfile);

    verify(
      () => mockRepo.upsertProfileRemote(remoteId, testAppRegisteredProfile),
    ).called(1);
    expect(container.read(appRegisteredProfileProvider).hasValue, true);
  });

  test(
    'updateProfile does not reload and returns false on failure / conflict',
    () async {
      when(
        () => mockRepo.upsertProfileRemote(
          any(),
          any(),
          checkForConflicts: true,
        ),
      ).thenAnswer((_) async => false);

      final notifier = container.read(appRegisteredProfileProvider.notifier);
      await notifier.updateProfile(
        remoteId,
        testAppRegisteredProfile,
        checkForConflicts: true,
      );
      verifyNever(() => mockRepo.getProfile(any()));
    },
  );
}
