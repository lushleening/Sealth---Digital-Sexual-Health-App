// CODEGEN RELATED: "dart run build_runner watch"
import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/database/drift_sqlite/dao/users_dao.dart';
import 'package:sddp_dsh/database/drift_sqlite/database_riverpod.dart';
import 'package:sddp_dsh/user/supabase_auth.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String localId,
    String? supabaseId,
    required bool isGuest,
    required DateTime lastLoggedIn,
  }) = _AppUser;
}

extension AppUserX on AppUser {
  bool get isRegistered => !isGuest && supabaseId != null;
}

@Riverpod(keepAlive: true)
class AppUserNotifier extends _$AppUserNotifier {
  late final SupabaseAuth _auth;
  late final UsersDAO _dao = UsersDAO(ref.read(databaseProvider));
  StreamSubscription<AuthState>? _authSub;

  @override
  Future<AppUser> build() {
    _auth = ref.read(supabaseAuthProvider);
    _authSub = _auth.onAuthStateChange.listen((data) async {
      final user = data.session?.user;
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        return user == null ? createLocalGuest() : loginNewRegisteredUser(user);
      });
    });
    ref.onDispose(() {
      _authSub?.cancel();
    });
    final currentUser = _auth.currentUser;
    return currentUser == null
        ? createLocalGuest()
        : loginNewRegisteredUser(currentUser);
  }

  Future<AppUser> createLocalGuest() async {
    authLogger.info("Generating a new guest user...");
    return await _dao.getOrCreateNewGuest();
  }

  Future<AppUser> loginNewRegisteredUser(User user) async {
    authLogger.info(
      "Login to supabase and getting the user from local database...",
    );
    return await _dao.getOrCreateRegisteredUser(user.id);
  }
}
// TODO
// Future<AppUser> removeLocalGuest() async {
//   authLogger.info("Removing current guest user...");
//   // return await _dao.getOrCreateNewGuest();
// }

// TODO: What if its offline (cached user?)

// TODO: Important
// if (_auth.currentSession?.isExpired == true) {
//   await _auth.refreshSession();
// }
