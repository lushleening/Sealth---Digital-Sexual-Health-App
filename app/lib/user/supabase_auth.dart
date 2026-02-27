import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_auth.g.dart';

@Riverpod(keepAlive: true)
SupabaseAuth supabaseAuth(Ref ref) {
  return SupabaseAuth();
}

@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  return ref.watch(supabaseAuthProvider).currentUser;
}

// Supabase Authentication Service
class SupabaseAuth {
  final _auth = Supabase.instance.client.auth;
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
  User? get currentUser => _auth.currentUser;

  Future<AuthResponse> registerEmailPassword({
    required String email,
    required String password,
  }) async {
    authLogger.info("SupabaseAuth: Account register by '$email'");
    return await _auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    authLogger.info("SupabaseAuth: Login by '$email'");
    return await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    await _auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.htleas.com://login-callback',
    );
  }

  Future<void> signInWithApple() async {
    await _auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.htleas.com://login-callback',
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    authLogger.info("SupabaseAuth: Password reset by '$email'");
    await _auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.htleas.com://reset-password',
    );
    // TODO await _auth.updateUser(UserAttributes(password: 'NEW_PASSWORD'));
  }
}
