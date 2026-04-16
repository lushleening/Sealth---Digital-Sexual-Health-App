import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

import '../../helper/mock_objects.dart';

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
        appNotificationProvider.overrideWith(TestAppNotificationNotifier.new)
      ],
    );
  });

  test('State is fetched from other providers', () async {
    final state = await container.read(userContextProvider.future);
    expect(state.user, testGuestAppUser);
    expect(state.profile, testAppRegisteredProfile);
    expect(state.settings, testAppSettings);
    expect(state.notifications, testAppNotifications);
  });
}
