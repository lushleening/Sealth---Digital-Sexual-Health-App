import 'package:sddp_dsh/backend/constants/textbox_hints.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Returns (emailError, passwordError), both nullable
(String?, String?) handleAuthException(AuthException e) {
  String? emailError;
  String? passwordError;
  switch (e.code) {
    case 'invalid_credentials':
      emailError = 'Invalid email or password';
      passwordError = 'Invalid email or password';
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
