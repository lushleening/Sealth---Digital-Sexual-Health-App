import 'package:sddp_dsh/backend/constants/text_hints.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Returns (emailError, passwordError), both nullable
(String?, String?) handleAuthException(AuthException e) {
  String? emailError;
  String? passwordError;

  if (handleConnectionException(e)) return (null, null);

  switch (e.code) {
    case 'invalid_credentials':
      emailError = 'Incorrect email or password';
      passwordError = 'Incorrect email or password';
      break;
    case 'user_already_exists':
      emailError = 'An account with this email already exists';
      break;
    case 'email_exists':
      emailError = 'An account with this email already exists';
      break;
    case 'email_address_invalid':
      emailError = 'Invalid email address';
      break;
    case 'weak_password':
      passwordError = 'Your password is too weak, use a stronger password';
      break;
    case 'over_email_send_rate_limit':
      emailError =
          "You have sent to much requests at the same time.\nTry again after a few minutes.";
      break;
    default:
      emailError = unexpectedInformDev;
      passwordError = unexpectedInformDev;
      authLogger.shout("$unexpectedErr: $e");
  }
  return (emailError, passwordError);
}

bool handleConnectionException(AuthException e) {
  if (e.message.contains('Failed host lookup')) {
    showSnackbarMessage(checkYourConnection);
    return true; // Caught exception
  }
  return false;
}
