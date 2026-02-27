import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/database/drift_sqlite/dao/profiles_dao.dart';
import 'package:sddp_dsh/database/drift_sqlite/database_riverpod.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/user/registered_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_repository.g.dart';

// Get local before trying to get remote
class ProfileRepository {
  final ProfilesDAO dao;
  final SupabaseClient supabase;

  ProfileRepository({required this.dao, required this.supabase});

  Future<RegisteredProfile?> getProfile(
    String supabaseId,
    String? email,
  ) async {
    final remote = await _fetchRemote(supabaseId, email);
    if (remote != null) _cacheLocal(remote);

    final local = await _tryLocal(supabaseId);
    return local;
  }

  Future<RegisteredProfile?> _tryLocal(String supabaseId) async {
    dbLogger.info("Trying to fetch profile data from local db...");
    return await dao.getProfile(supabaseId);
  }

  Future<RegisteredProfile?> _fetchRemote(
    String supabaseId,
    String? email,
  ) async {
    dbLogger.info("Trying to fetch profile data from remote db...");
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('supabase_id', supabaseId)
          .single();
      return RegisteredProfile.fromJson(response).copyWith(email: email);
    } catch (e) {
      dbLogger.severe('Unable to fetch remote data: $e');
      return null;
    }
  }

  Future<void> _cacheLocal(RegisteredProfile profile) async {
    dbLogger.info("Caching data from remote db -> local db...");
    await dao.insertOrUpdate(profile);
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  final dao = ref.read(profilesDAOProvider);
  final supabase = Supabase.instance.client;
  return ProfileRepository(dao: dao, supabase: supabase);
}
