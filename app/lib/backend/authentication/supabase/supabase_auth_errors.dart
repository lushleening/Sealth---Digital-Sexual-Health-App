import 'package:sddp_dsh/backend/constants/text_hints.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
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
    default:
      emailError = unexpectedInformDev;
      passwordError = unexpectedInformDev;
      authLogger.shout("An unexpected error occured: $e");
  }
  return (emailError, passwordError);
}

bool handleConnectionException(AuthException e) {
  if (e.message.contains('Failed host lookup')) {
    showSnackbarMessage('Unable to connect to server. Check your connection.');
    return true; // Caught exception
  }
  return false;
}
