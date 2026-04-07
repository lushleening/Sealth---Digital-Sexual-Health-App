import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

import '../../helper/mock_objects.dart';

// Mocking the repository and other services
class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockBiometricConfirmation extends Mock implements BiometricConfirmation {}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test(
      overrides: [
        appUserProvider.overrideWith(TestAppGuestNotifier.new),
        appRegisteredProfileProvider.overrideWith(
          TestAppRegisteredProfileNotifier.new,
        ),
        appSettingsProvider.overrideWith(TestAppSettingsNotifier.new),
      ],
    );
  });

  test('State is fetched from other providers', () async {
    final state = await container.read(userContextProvider.future);
    expect(state.user, testGuestAppUser);
    expect(state.profile, testAppRegisteredProfile);
    expect(state.settings, testAppSettings);
  });
}
