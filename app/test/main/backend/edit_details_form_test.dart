import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/constants/input_control.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/personal_info/edit_details/edit_details_form.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helper/mock_objects.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseAuth extends Mock implements SupabaseAuth {}

const email = 'test@email.com';
const password = 'password123';

void main() {
  late ProviderContainer container;
  late MockAppRegisteredProfileNotifier mockProfile;
  setUp(() {
    mockProfile = MockAppRegisteredProfileNotifier();
    container = ProviderContainer.test(
      overrides: [
        supabaseServiceProvider.overrideWithValue(MockSupabaseClient()),
        appRegisteredProfileProvider.overrideWith(() => mockProfile),
        appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
        appSettingsProvider.overrideWith(TestAppSettingsNotifier.new),
        supabaseHealthCheckProvider.overrideWith((_) async => true),
      ],
    );

    registerFallbackValue(testAppRegisteredProfile);
    when(
      () => mockProfile.updateProfile(
        any(),
      ),
    ).thenAnswer((_) async => {});
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group("changeUsername works as expected", () {
    group("Fails on invalid input", () {
      test("Fail on empty username - updateProfile is not called", () async {
        final notifier = container.read(editDetailsFormProvider.notifier);
        final profile = testAppRegisteredProfile.copyWith(username: '');

        await notifier.toggleInputEnabled();
        expect(container.read(editDetailsFormProvider).inputEnabled, true); // false != true

        await notifier.changeUsername(remoteId, username, profile);

        verifyNever(
          () => mockProfile.updateProfile(
            profile,
          ),
        );
      });

      test("Fail on same username - updateProfile is not called", () async {
        final notifier = container.read(editDetailsFormProvider.notifier);
        final profile = testAppRegisteredProfile.copyWith(username: username);

        await notifier.toggleInputEnabled();
        expect(container.read(editDetailsFormProvider).inputEnabled, true);

        await notifier.changeUsername(remoteId, username, profile);

        verifyNever(
          () => mockProfile.updateProfile(
            profile,
          ),
        );
      });

      test("Fails on no inputEnabled", () async {
        final notifier = container.read(editDetailsFormProvider.notifier);
        final profile = testAppRegisteredProfile.copyWith(username: username);

        expect(container.read(editDetailsFormProvider).inputEnabled, false);

        await notifier.changeUsername(remoteId, newUsername, profile);
        verifyNever(
          () => mockProfile.updateProfile(
            profile.copyWith(username: newUsername),
          ),
        );
      });
    });

    test("Success on valid input", () async {
      final notifier = container.read(editDetailsFormProvider.notifier);
      final profile = testAppRegisteredProfile.copyWith(username: username);

      await notifier.toggleInputEnabled();
      expect(container.read(editDetailsFormProvider).inputEnabled, true);

      await notifier.changeUsername(remoteId, newUsername, profile);
      verify(
        () => mockProfile.updateProfile(
          profile.copyWith(username: newUsername),
        ),
      ).called(1);
    });
  });

  test("setUsernameError works as expected", () {
    final notifier = container.read(editDetailsFormProvider.notifier);
    notifier.setUsernameError('');
    expect(container.read(editDetailsFormProvider).usernameError, isNotNull);
    notifier.clearAllErrors();

    notifier.setUsernameError('c' * (maxUsernameLen + 1));
    expect(container.read(editDetailsFormProvider).usernameError, isNotNull);
    notifier.clearAllErrors();

    notifier.setUsernameError('user123');
    expect(container.read(editDetailsFormProvider).usernameError, isNull);
  });

  group("pickAvatar works as expected", () {
    group("Fails on invalid conditions", () {
      test("Fails on no inputEnabled", () async {
        final notifier = container.read(editDetailsFormProvider.notifier);
        final profile = testAppRegisteredProfile.copyWith(username: username);
        expect(container.read(editDetailsFormProvider).inputEnabled, false);
        bool uploadCalled = false;
        await notifier.pickAvatar(
          remoteId,
          profile,
          uploadOverride: (client, file, id) async {
            uploadCalled = true;
            return "https://fake-url.com";
          },
          pickAvatarOverride: () async => File('fake-path'),
        );
        expect(uploadCalled, false);
      });

      test("Fails on no file chosen", () async {
        final notifier = container.read(editDetailsFormProvider.notifier);
        final profile = testAppRegisteredProfile.copyWith(username: username);

        await notifier.toggleInputEnabled();
        expect(container.read(editDetailsFormProvider).inputEnabled, true);

        bool uploadCalled = false;
        await notifier.pickAvatar(
          remoteId,
          profile,
          uploadOverride: (client, file, id) async {
            uploadCalled = true;
            return "https://fake-url.com";
          },
          pickAvatarOverride: () async => null,
        );
        expect(uploadCalled, false);
      });
    });

    test("Success on valid input", () async {
      final notifier = container.read(editDetailsFormProvider.notifier);
      final profile = testAppRegisteredProfile.copyWith(username: username);

      await notifier.toggleInputEnabled();
      expect(container.read(editDetailsFormProvider).inputEnabled, true);

      bool uploadCalled = false;
      await notifier.pickAvatar(
        remoteId,
        profile,
        uploadOverride: (client, file, id) async {
          uploadCalled = true;
          return "https://fake-url.com";
        },
        pickAvatarOverride: () async => File('fake-path'),
      );
      expect(uploadCalled, true);
    });
  });
}
