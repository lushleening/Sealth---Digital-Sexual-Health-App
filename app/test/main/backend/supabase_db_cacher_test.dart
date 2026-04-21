import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_cacher.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_fetcher.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late MockSupabaseDBFetcher mockFetcher;
  late MockUsersRepository mockUsersRepo;
  late MockProfilesRepository mockProfilesRepo;
  late MockSettingsRepository mockSettingsRepo;

  setUp(() async {
    mockFetcher = MockSupabaseDBFetcher();
    mockUsersRepo = MockUsersRepository();
    mockProfilesRepo = MockProfilesRepository();
    mockSettingsRepo = MockSettingsRepository();

    container = ProviderContainer.test(
      overrides: [
        supabaseDBFetcherProvider.overrideWithValue(mockFetcher),
        usersRepositoryProvider.overrideWithValue(mockUsersRepo),
        profilesRepositoryProvider.overrideWithValue(mockProfilesRepo),
        settingsRepositoryProvider.overrideWithValue(mockSettingsRepo),
        supabaseHealthCheckProvider.overrideWith((_) async => true),
      ],
    );

    container.listen(appRegisteredProfileProvider, (_, _) {});
    container.listen(appSettingsProvider, (_, _) {});
    await pumpEventQueue();
  });

  test("SupabaseDBCacher successfully caches all the data required", () async {
    // Mock the user lookup
    when(
      () => mockUsersRepo.getRegisteredUser(remoteId),
    ).thenAnswer((_) async => testRegisteredAppUser);

    // Mock the fetcher calls
    when(
      () => mockFetcher.fetchSingle(remoteId, FetchTools.profiles),
    ).thenAnswer((_) async => testAppRegisteredProfile);
    when(
      () => mockFetcher.fetchMaybeSingle(remoteId, FetchTools.settings),
    ).thenAnswer((_) async => testAppSettings);

    // Mock the repository saves
    when(
      () => mockProfilesRepo.upsertProfile(remoteId, testAppRegisteredProfile),
    ).thenAnswer((_) async => true);
    when(
      () => mockSettingsRepo.upsertSetting(localId, testAppSettings),
    ).thenAnswer((_) async => true);

    // Execute
    final cacher = container.read(supabaseDBCacherProvider);
    await cacher.cacheRemoteToLocal(remoteId);

    // Verify calls happened
    verify(
      () => mockProfilesRepo.upsertProfile(remoteId, testAppRegisteredProfile),
    ).called(1);
    verify(
      () => mockSettingsRepo.upsertSetting(localId, testAppSettings),
    ).called(1);
  });
}
