// import 'package:email_validator/email_validator.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
// import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth_errors.dart';
// import 'package:sddp_dsh/backend/logging/app_loggers.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// part 'edit_details_form.freezed.dart';
// part 'edit_details_form.g.dart';


// // Used to display auth form UI
// @freezed
// abstract class EditDetailsFormState with _$EditDetailsFormState {
//   const factory EditDetailsFormState({
//     String? emailError,
//     String? passwordError,
//     String? confirmPasswordError,
//     @Default(false) bool submitting,
//     @Default(true) bool hidePassword,
//     @Default(true) bool hideConfirmPassword,
//   }) = _EditDetailsFormState;
// }

// // Used to validate auth forms
// @riverpod
// class EditDetailsNotifier extends _$EditDetailsNotifier {

//   @override
//   EditDetailsFormState build() {
//     return const EditDetailsFormState();
//   }

//   Future<bool> submit({required String email, String? password}) async {
//     // Quick check for errors before submitting to remote db
//     authLogger.finer("Validating credentials locally");
//     final emailError = emailValidator(email);
//     final passwordError = type == EditDetailsType.forgotPassword
//         ? null
//         : passwordValidator(password);
//     state = state.copyWith(
//       emailError: emailError,
//       passwordError: passwordError,
//     );
//     if (emailError != null || passwordError != null) return false;

//     // Starts submitting to remote db if found no errors
//     state = state.copyWith(submitting: true);
//     editProfileLogger.finer("Submitting edited profile to respective databases");
//     try {
//       // TODO Submit change to local db
//       // TODO OR remote id if regarding password and email 
//     } on AuthException catch (e) {
//       final (ee, pe) = handleAuthException(e);
//       authLogger.finer(
//         "Email error: $emailError\nPassword error: $passwordError",
//       );
//       state = state.copyWith(emailError: ee, passwordError: pe);
//       return false;
//     } finally {
//       state = state.copyWith(submitting: false);
//     }
//     authLogger.finer("Authentication request succeeded");
//     return true;
//   }

//   // Login TODO handle google login
//   Future<void> _handleLogin(String email, String password) async {
//     await ref
//         .read(supabaseAuthProvider)
//         .loginWithEmailPassword(email: email, password: password);
//   }

//   // Register
//   Future<void> _handleRegister(String email, String password) async {
//     await ref
//         .read(supabaseAuthProvider)
//         .registerEmailPassword(email: email, password: password);
//   }

//   // Forgot password
//   Future<void> _handleForgotPassword(String email) async {
//     authLogger.warning("Handle forgot password here");
//     // final auth = ref.read(supabaseAuthProvider);
//     // TODO await auth.resetPassword(email);
//   }

//   // UI Display
//   void clearAllErrors() {
//     uiLogger.finer("Clearing all auth errors");
//     state = state.copyWith(
//       emailError: null,
//       passwordError: null,
//       confirmPasswordError: null,
//     );
//   }

//   void toggleHidePassword() {
//     uiLogger.finer("Toggle hide passwords");
//     state = state.copyWith(hidePassword: !state.hidePassword);
//   }

//   void toggleHideConfirmPassword() {
//     uiLogger.finer("Toggle confirm hide passwords");
//     state = state.copyWith(hideConfirmPassword: !state.hideConfirmPassword);
//   }

//   void onEmailChanged(String _) {
//     if (state.emailError != null) {
//       state = state.copyWith(emailError: null);
//     }
//   }

//   void onPasswordChanged(String _) {
//     if (state.passwordError != null) {
//       state = state.copyWith(passwordError: null);
//     }
//   }

//   void onConfirmPasswordChanged(String _) {
//     if (state.confirmPasswordError != null) {
//       state = state.copyWith(confirmPasswordError: null);
//     }
//   }

//   String? emailValidator(String? email) {
//     return email == null || email.isEmpty
//         ? "Email is a required field."
//         : !EmailValidator.validate(email)
//         ? "Invalid email format."
//         : null;
//   }

//   String? passwordValidator(String? password) {
//     return password == null || password.isEmpty
//         ? "Password is a required field."
//         : password.length < 6
//         ? "Password length should not be less than 6 characters"
//         : null;
//   }

//   String? confirmPasswordValidator(String? confirmPassword, String? password) {
//     return password == null || password.isEmpty
//         ? "Please confirm your password."
//         : confirmPassword != password
//         ? "Passwords should be the same."
//         : null;
//   }
// }
