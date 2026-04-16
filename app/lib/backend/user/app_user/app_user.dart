import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_cacher.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_rt_service.dart';
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
        final user = data.session?.user;

        if (event == AuthChangeEvent.passwordRecovery) {
          authLogger.info(
            "Password recovery session detected. Blocking auto-login.",
          );
          await _auth.signOut();
          return;
        }

        if (user?.id == state.value?.remoteId) return;

        // Sign in
        if (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.initialSession) {
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

      // Subscribe to article updates for all users (including guests)
      ref.read(supabaseRTServiceProvider).subscribeToArticles();

      if (remoteId != null) {
        // Initial fetch first to ensure all data exists
        await ref.read(supabaseDBCacherProvider).cacheRemoteToLocal(remoteId);

        // Get a subscription channel for realtime updates
        ref
            .read(supabaseRTServiceProvider)
            .subscribeToAll(localId: currentUser.localId, remoteId: remoteId);
      }
      localDBLogger.info("Current user has been cached to local db");

      // Only sync appointments for logged in users
      final syncService = ref.read(appointmentSyncServiceProvider);
      syncService.syncClinics().catchError((_) {});
      syncService.syncServices().catchError((_) {});
      if (remoteId != null) {
        syncService.syncAppointments().catchError((_) {});
      }

      // Clean up old notifications
      await ref.read(notificationsRepositoryProvider).cleanupOldNotifications();

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
