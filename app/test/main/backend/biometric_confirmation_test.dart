import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:test/test.dart';

import '../../helper/mock_objects.dart';

void main() {
  late MockLocalAuthentication mockAuth;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAuth = MockLocalAuthentication();
  });

  test("Returns true on local auth success", () async {
    final container = ProviderContainer.test(
      overrides: [
        appSettingsProvider.overrideWith(TestHasBioSettingsNotifier.new),
      ],
    );
    container.listen(appSettingsProvider, (_, _) {});

    when(
      () => mockAuth.authenticate(
        localizedReason: any(named: 'localizedReason'),
        biometricOnly: any(named: 'biometricOnly'),
        persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
      ),
    ).thenAnswer((_) async => true);

    final result = await container
        .read(biometricConfirmationProvider)
        .tryBiometricConfirmation(localAuth: mockAuth);

    expect(result, isTrue);
  });

  test("Returns false on local auth exist but failed", () async {
    final container = ProviderContainer.test(
      overrides: [
        appSettingsProvider.overrideWith(TestHasBioSettingsNotifier.new),
      ],
    );
    container.listen(appSettingsProvider, (_, _) {});

    when(
      () => mockAuth.authenticate(
        localizedReason: any(named: 'localizedReason'),
        biometricOnly: any(named: 'biometricOnly'),
        persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
      ),
    ).thenThrow(LocalAuthException(code: LocalAuthExceptionCode.userCanceled));

    final result = await container
        .read(biometricConfirmationProvider)
        .tryBiometricConfirmation(localAuth: mockAuth);

    expect(result, isFalse);
  });

  test(
    "Returns null on local auth if biometric method does not exist",
    () async {
      final container = ProviderContainer.test(
        overrides: [
          appSettingsProvider.overrideWith(TestHasBioSettingsNotifier.new),
        ],
      );
      container.listen(appSettingsProvider, (_, _) {});

      when(
        () => mockAuth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
        ),
      ).thenThrow(PlatformException(code: 'NotAvailable'));

      final result = await container
          .read(biometricConfirmationProvider)
          .tryBiometricConfirmation(localAuth: mockAuth);

      expect(result, isNull);
    },
  );

  test("Returns null on local auth if settings does not allow", () async {
    final container = ProviderContainer.test(
      overrides: [
        appSettingsProvider.overrideWith(TestNoBioSettingsNotifier.new),
      ],
    );
    container.listen(appSettingsProvider, (_, _) {});

    final result = await container
        .read(biometricConfirmationProvider)
        .tryBiometricConfirmation(localAuth: mockAuth);

    expect(result, isNull);
    verifyNever(
      () => mockAuth.authenticate(
        localizedReason: any(named: 'localizedReason'),
        biometricOnly: any(named: 'biometricOnly'),
        persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
      ),
    );
  });

  test(
    "Runs on local auth if settings does not allow yet bypass settings in true",
    () async {
      final container = ProviderContainer.test(
        overrides: [
          appSettingsProvider.overrideWith(TestNoBioSettingsNotifier.new),
        ],
      );
      container.listen(appSettingsProvider, (_, _) {});

      final result = await container
          .read(biometricConfirmationProvider)
          .tryBiometricConfirmation(
            localAuth: mockAuth,
            bypassSettingCheck: true,
          );

      expect(result, isNull);
      verify(
        () => mockAuth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
        ),
      ).called(1);
    },
  );
}
