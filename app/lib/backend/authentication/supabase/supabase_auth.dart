import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_auth.g.dart';

// Provider
@Riverpod(keepAlive: true)
SupabaseAuth supabaseAuth(Ref ref) {
  return SupabaseAuth(client: ref.watch(supabaseServiceProvider));
}

// Supabase Authentication Service
class SupabaseAuth {
  final SupabaseClient client;
  SupabaseAuth({required this.client});

  late final _auth = client.auth;
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
  User? get currentUser => _auth.currentUser;
  String? get email => _auth.currentUser?.email;

  Future<AuthResponse> registerEmailPassword(
    String email,
    String password,
  ) async {
    authLogger.info("Account register with email: '$email'");
    return await _auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    authLogger.info("Logging in with email: '$email'");
    return await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    authLogger.info("Signing in with Google...");
    await _auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: deepLinkLoginCallback,
    );
  }

  Future<void> signInWithApple() async {
    authLogger.info("Signing in with Apple...");
    await _auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: deepLinkLoginCallback,
    );
  }

  Future<void> signOut() async {
    authLogger.info("Signing out...");
    await _auth.signOut();
  }

  Future<void> sendResetEmail(String email) async {
    authLogger.info("Password reset by email: '$email'");
    await _auth.resetPasswordForEmail(
      email,
      redirectTo: deepLinkResetPassword,
    );
    showSnackbarMessage(
      "A message has been sent to your email. Click the link inside the email to continue resetting your password.",
    );
  }

  Future<void> resetPassword(String email, String newPassword) async {
    authLogger.info("Password reset by email: '$email'");
    await _auth.updateUser(UserAttributes(password: newPassword));
    showSnackbarMessage(
      "Password successfully resetted. Try signing in again.",
    );
  }
}
