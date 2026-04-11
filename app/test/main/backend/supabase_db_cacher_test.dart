import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_cacher.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_fetcher.dart';

import '../../helper/mock_objects.dart';

class MockSupabaseDBFetcher extends Mock implements SupabaseDBFetcher {}

class MockUsersRepository extends Mock implements UsersRepository {}

class MockProfilesRepository extends Mock implements ProfilesRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late ProviderContainer container;
  late MockSupabaseDBFetcher mockFetcher;
  late MockUsersRepository mockUsersRepo;
  late MockProfilesRepository mockProfilesRepo;
  late MockSettingsRepository mockSettingsRepo;

  setUp(() {
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
      ],
    );
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

// DB fetchers are too coupled with supabase functions and subject to Supabase API change thus not testing it
