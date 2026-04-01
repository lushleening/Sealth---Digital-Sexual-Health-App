import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth_errors.dart';
import 'package:sddp_dsh/backend/constants/text_hints.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('Maps error codes correctly', () {
    final cases = {
      "invalid_credentials": (
        "Incorrect email or password",
        "Incorrect email or password",
      ),
      "user_already_exists": (
        "An account with this email already exists",
        null,
      ),
      "email_exists": ('An account with this email already exists', null),
      "email_address_invalid": ("Invalid email address", null),
      "weak_password": (
        null,
        "Your password is too weak, use a stronger password",
      ),
      "over_email_send_rate_limit": (
        "You have sent to much requests at the same time.\nTry again after a few minutes.",
        null,
      ),
    };

    cases.forEach((code, expected) {
      final result = handleAuthException(AuthException('error', code: code));
      expect(result.$1, expected.$1, reason: 'Failed on code: $code (email)');
      expect(
        result.$2,
        expected.$2,
        reason: 'Failed on code: $code (password)',
      );
    });
  });

  test('Unknown error code returns default message and logs', () {
    final exception = AuthException('Unknown', code: '&^*^&');
    final (emailErr, passErr) = handleAuthException(exception);
    expect(emailErr, unexpectedInformDev);
    expect(passErr, unexpectedInformDev);
  });

  group('handleConnectionException Tests', () {
    test('Returns true on failed host lookup', () {
      TestWidgetsFlutterBinding.ensureInitialized(); // For snackbar
      final exception = AuthException('Failed host lookup: supabase.co');
      final result = handleConnectionException(exception);
      expect(result, isTrue);
    });

    test('Returns false on other messages', () {
      final exception = AuthException('Timeout', code: '408');
      final result = handleConnectionException(exception);
      expect(result, isFalse);
    });
  });
}
