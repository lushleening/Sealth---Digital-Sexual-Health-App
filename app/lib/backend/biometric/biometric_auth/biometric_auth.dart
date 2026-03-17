import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/textbox_hints.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';

part 'biometric_auth.g.dart';

// Provider
@riverpod
BiometricAuth biometricAuth(Ref ref) {
  return BiometricAuth(ref: ref);
}

class BiometricAuth {
  final Ref ref;
  BiometricAuth({required this.ref});

  // True -> Pass
  // Null -> Error (Still Pass)
  // False -> Reject
  Future<bool?> tryBiometricAuth({bool bypassSettingCheck = false}) async {
    // Check if app settings allow biometrics first
    if (!bypassSettingCheck) {
      final settings = await ref.read(appSettingsProvider.future);
      final bioEnabled = settings.biometricAuthentication;
      if (!bioEnabled) return null;
    }

    final auth = LocalAuthentication();

    try {
      authLogger.info("Attempting biometric authentication");
      return await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (e) {
      // Only if user / system specifically cancels the process, treat as unauthorized
      if (e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.systemCanceled) {
        return false;
      } else {
        // Otherwise treat as no biometric methods and proceed
        authLogger.shout("An error occured: $e");
      }
    } catch (e) {
      // If unexpected error occurs
      authLogger.severe("$unexpectedInformDev: $e");
      showSnackbarMessage(unexpectedInformDev);
    }
    return null;
  }
}
