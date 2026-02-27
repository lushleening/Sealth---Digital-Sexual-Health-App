// CODEGEN RELATED: "dart run build_runner watch"
import 'package:email_validator/email_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/user/supabase_auth.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/user/registered_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO Confirm password for register
part 'auth_form.freezed.dart';
part 'auth_form.g.dart';

enum AuthFormType { login, register, forgotPassword }

@freezed
abstract class AuthFormState with _$AuthFormState {
  const factory AuthFormState({
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    @Default(false) bool submitting,
    @Default(true) bool hidePassword,
    @Default(true) bool hideConfirmPassword,
  }) = _AuthFormState;
}

@riverpod
class AuthFormNotifier extends _$AuthFormNotifier {
  late final AuthFormType type;

  @override
  AuthFormState build(AuthFormType formType) {
    type = formType;
    return const AuthFormState();
  }

  void toggleHidePassword() {
    state = state.copyWith(hidePassword: !state.hidePassword);
  }

  void toggleHideConfirmPassword() {
    state = state.copyWith(hideConfirmPassword: !state.hideConfirmPassword);
  }

  void onEmailChanged(String _) {
    if (state.emailError != null) {
      state = state.copyWith(emailError: null);
    }
  }

  void onPasswordChanged(String _) {
    if (state.passwordError != null) {
      state = state.copyWith(passwordError: null);
    }
  }

  void onConfirmPasswordChanged(String _) {
    if (state.confirmPasswordError != null) {
      state = state.copyWith(confirmPasswordError: null);
    }
  }

  Future<bool> submit({required String email, String? password}) async {
    // Quick check for errors before submitting to supabase to validate
    final emailError = emailValidator(email);
    final passwordError = type == AuthFormType.forgotPassword
        ? null
        : passwordValidator(password);

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );
    if (emailError != null || passwordError != null) return false;

    state = state.copyWith(submitting: true);
    final auth = ref.read(supabaseAuthProvider);
    try {
      switch (type) {
        case AuthFormType.login:
          await _handleLogin(auth, email, password!);
          break;
        case AuthFormType.register:
          await _handleRegister(auth, email, password!);
          break;
        case AuthFormType.forgotPassword:
          await _handleForgotPassword(auth, email);
          break;
      }
    } on AuthException catch (e) {
      _handleAuthException(e);
      return false;
    } finally {
      state = state.copyWith(submitting: false);
    }
    return true;
  }

  String? emailValidator(String? email) {
    return email == null || email.isEmpty
        ? "Email is a required field."
        : !EmailValidator.validate(email)
        ? "Invalid email format."
        : null;
  }

  String? passwordValidator(String? password) {
    return password == null || password.isEmpty
        ? "Password is a required field."
        : password.length < 6
        ? "Password length should not be less than 6 characters"
        : null;
  }

  String? confirmPasswordValidator(String? confirmPassword, String? password) {
    return password == null || password.isEmpty
        ? "Please confirm your password."
        : confirmPassword != password
        ? "Passwords should be the same."
        : null;
  }

  void _handleAuthException(AuthException e) {
    switch (e.code) {
      case 'invalid_credentials':
        state = state.copyWith(
          emailError: 'Invalid email or password',
          passwordError: 'Invalid email or password',
        );
        break;
      case 'user_already_exists':
        state = state.copyWith(
          emailError: 'An account with this email already exists',
        );
        break;
      case 'email_exists':
        state = state.copyWith(
          emailError: 'An account with this email already exists',
        );
        break;
      case 'email_address_invalid':
        state = state.copyWith(emailError: 'Invalid email address');
        break;
      case 'weak_password':
        state = state.copyWith(
          passwordError: 'Your password is too weak, use a stronger password',
        );
        break;
      default:
        state = state.copyWith(
          emailError: unexpectedInformDev,
          passwordError: unexpectedInformDev,
        );
        authLogger.shout("Auth Form Error :: $e");
        break;
    }
  }

  Future<void> _handleLogin(
    SupabaseAuth auth,
    String email,
    String password,
  ) async {
    final result = await auth.loginWithEmailPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    if (user == null) {
      throw AuthException(
        "Could not find a user",
        statusCode: "EOF",
        code: "This should not occur",
      );
    }
    await ref.read(registeredProfileProvider(user.id).notifier).reload(user.id);
    // ref.read(appStatusProvider.notifier).setAuthenticated(); // TODO state fix here getHome won't rebuild
  }

  Future<void> _handleRegister(
    SupabaseAuth auth,
    String email,
    String password,
  ) async {
    final result = await auth.registerEmailPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    if (user == null) {
      throw AuthException(
        "Could not find a user",
        statusCode: "EOF",
        code: "This should not occur",
      );
    }
    await ref.read(registeredProfileProvider(user.id).notifier).reload(user.id);
  }

  Future<void> _handleForgotPassword(SupabaseAuth auth, String email) async {
    authLogger.warning("Handle forgot password here");
    // TODO await auth.resetPassword(email);
  }
}
