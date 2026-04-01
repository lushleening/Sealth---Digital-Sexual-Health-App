import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_cacher.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

// All users have their own AppUser
// Totally local class, used to bind user and their functionality classes together in the app only
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String localId,
    String? remoteId,
    required DateTime lastLoggedIn,
  }) = _AppUser;
}

// Provider watches remote authentication service to check if logged in as other user
// If so, log the user in local db and rebuild the provider
@Riverpod(keepAlive: true)
class AppUserNotifier extends _$AppUserNotifier {
  late final UsersRepository _repo = ref.read(usersRepositoryProvider);
  late final SupabaseAuth _auth = ref.read(supabaseAuthProvider);
  StreamSubscription<AuthState>? _authSub;

  @override
  Future<AppUser> build() {
    _authSub = _auth.onAuthStateChange.listen((data) async {
      final event = data.event;

      // Sign in
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.initialSession) {
        final user = data.session?.user;
        ref.invalidate(userAppointmentsProvider);
        if (!state.isLoading) state = AsyncLoading();
        state = await AsyncValue.guard(() => loginUser(user));
      }

      // Sign out
      if (event == AuthChangeEvent.signedOut) {
        ref.invalidate(userAppointmentsProvider);
        state = await AsyncValue.guard(() => loginUser(null));
      }
    });
    ref.onDispose(() {
      _authSub?.cancel();
    });
    return loginUser(_auth.currentUser);
  }

  Future<AppUser> loginUser(User? user) async {
    // Insert user to db
    final currentUser = await (user == null
        ? _repo.getOrCreateGuest()
        : _repo.getOrInsertRegisteredUser(user.id));
    authLogger.info("Current user has been logged in: $currentUser");

    // Cache remote -> local db
    final remoteId = currentUser.remoteId;
    if (remoteId != null) {
      await ref.read(supabaseDBCacherProvider).cacheRemoteToLocal(remoteId);
    }
    localDBLogger.info("Current user has been cached to local db");

    // Update user's login time
    return await _repo.updateLastLoginAndReturn(currentUser.localId);
  }

  Future<void> refreshLocalGuest() async {
    localDBLogger.info("Refreshing current guest user");
    await _repo.deleteGuestUser();
    if (!state.isLoading) state = AsyncLoading();
    state = await AsyncValue.guard(_repo.insertGuestUserAndReturn);
  }
}
