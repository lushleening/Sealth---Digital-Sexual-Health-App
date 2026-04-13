import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late MockProfilesRepository mockRepo;

  setUp(() async {
    mockRepo = MockProfilesRepository();
    container = ProviderContainer.test(
      overrides: [
        profilesRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
      ],
    );

    when(
      () => mockRepo.watchProfile(any()),
    ).thenAnswer((_) => Stream.value(testAppRegisteredProfile));

    container.listen(profilesRepositoryProvider, (_, _) {});
    container.listen(appRegisteredProfileProvider, (_, _) {});
    await pumpEventQueue();

    registerFallbackValue(testAppRegisteredProfile);
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Build returns profile when remoteId and profile exist', () async {
    when(
      () => mockRepo.watchProfile(remoteId),
    ).thenAnswer((_) => Stream.value(testAppRegisteredProfile));
    final result = await container.read(appRegisteredProfileProvider.future);
    expect(result, testAppRegisteredProfile);
    verify(() => mockRepo.watchProfile(remoteId)).called(1);
  });

  test('updateProfile reloads state on success', () async {
    when(
      () => mockRepo.getProfile(remoteId),
    ).thenAnswer((_) async => testAppRegisteredProfile);
    when(
      () => mockRepo.upsertProfileRemote(any(), any()),
    ).thenAnswer((_) async => true);

    final notifier = container.read(appRegisteredProfileProvider.notifier);
    await notifier.updateProfile(testAppRegisteredProfile);

    verify(
      () => mockRepo.upsertProfileRemote(remoteId, testAppRegisteredProfile),
    ).called(1);
    expect(container.read(appRegisteredProfileProvider).hasValue, true);
  });

  test(
    'updateProfile does not reload and returns false on failure / conflict',
    () async {
      when(
        () => mockRepo.upsertProfileRemote(any(), any()),
      ).thenAnswer((_) async => false);

      final notifier = container.read(appRegisteredProfileProvider.notifier);
      await notifier.updateProfile(testAppRegisteredProfile);
      verifyNever(() => mockRepo.getProfile(any()));
    },
  );
}
