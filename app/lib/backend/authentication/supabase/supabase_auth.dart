import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_auth.g.dart';

// Provider
@Riverpod(keepAlive: true)
SupabaseAuth supabaseAuth(Ref ref) {
  return SupabaseAuth(ref: ref);
}

// Supabase Authentication Service
class SupabaseAuth {
  final Ref ref;
  SupabaseAuth({required this.ref});

  final _auth = Supabase.instance.client.auth;
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
  User? get currentUser => _auth.currentUser;
  String? get email => _auth.currentUser?.email;

  Future<AuthResponse> registerEmailPassword({
    required String email,
    required String password,
  }) async {
    authLogger.info("Account register with email: '$email'");
    return await _auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    authLogger.info("Logging in with email: '$email'");
    return await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    authLogger.info("Signing in with Google...");
    await _auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.htleas.com://login-callback',
    );
  }

  Future<void> signInWithApple() async {
    authLogger.info("Signing in with Apple...");
    await _auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.htleas.com://login-callback',
    );
  }

  Future<void> updateUser({String? email, String? password}) async {
    await _auth.updateUser(UserAttributes(email: email, password: password));
  }

  Future<void> signOut() async {
    authLogger.info("Signing out...");
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
  //   authLogger.info("Password reset by email: '$email'");
  //   await _auth.resetPasswordForEmail(
  //     email,
  //     redirectTo: 'io.htleas.com://reset-password',
  //   );

  //   _auth.onAuthStateChange.listen((data) {
  //     final AuthChangeEvent event = data.event;
  //     if (event == AuthChangeEvent.passwordRecovery && context.mounted) {
  //       Navigator.pushNamed(context, '/update-password');
  //     }
  //   });
  }
}