import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late MockSettingsRepository mockRepo;

  setUp(() async {
    mockRepo = MockSettingsRepository();
    container = ProviderContainer.test(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith(TestAppGuestNotifier.new),
      ],
    );

    when(
      () => mockRepo.getSetting(any()),
    ).thenAnswer((_) async => testAppSettings);
    when(
      () => mockRepo.watchSetting(any()),
    ).thenAnswer((_) => Stream.value(testAppSettings));

    registerFallbackValue(testAppSettings);
    container.listen(settingsRepositoryProvider, (_, _) {});
    container.listen(appSettingsProvider, (_, _) {});
    await pumpEventQueue();
  });

  test('Initial state is fetched from repository', () async {
    final state = await container.read(appSettingsProvider.future);
    expect(state, testAppSettings);
    verify(() => mockRepo.getSetting(localId)).called(1);
    verify(() => mockRepo.watchSetting(localId)).called(1);
  });

  test('State rolls back to previous when repository update fails', () async {
    when(
      () => mockRepo.updateSettingAndSync(
        localId: any(named: 'localId'),
        remoteId: any(named: 'remoteId'),
        newSettings: any(named: 'newSettings'),
      ),
    ).thenThrow(Exception('Sync failed'));

    final notifier = container.read(appSettingsProvider.notifier);
    await notifier.setDarkMode(true);
    final state = container.read(appSettingsProvider).value;
    expect(state?.darkMode, false);
  });
}
