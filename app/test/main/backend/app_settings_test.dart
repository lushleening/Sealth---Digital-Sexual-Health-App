import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

import '../../helper/mock_objects.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockBiometricConfirmation extends Mock implements BiometricConfirmation {}

void main() {
  late ProviderContainer container;
  late MockSettingsRepository mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepository();

    container = ProviderContainer.test(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith(TestAppGuestNotifier.new),
      ],
    );

    when(
      () => mockRepo.getSettings(any()),
    ).thenAnswer((_) async => testAppSettings);

    registerFallbackValue(testAppSettings);
  });

  test('Initial state is fetched from repository', () async {
    final state = await container.read(appSettingsProvider.future);
    expect(state, testAppSettings);
    verify(() => mockRepo.getSettings(localId)).called(1);
  });

  test('State rolls back to previous when repository update fails', () async {
  when(() => mockRepo.updateSettingsAndSync(
    localId: any(named: 'localId'),
    remoteId: any(named: 'remoteId'),
    newSettings: any(named: 'newSettings'),
  )).thenThrow(Exception('Sync failed'));
  final notifier = container.read(appSettingsProvider.notifier);
  await notifier.setDarkMode(true);
  final state = await container.read(appSettingsProvider.future);
  expect(state.darkMode, false); 
});
}
