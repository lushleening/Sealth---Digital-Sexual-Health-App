import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_cacher.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_rt_service.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late MockSupabaseAuth mockAuth;
  late MockUsersRepository mockUsersRepo;
  late MockNotificationsRepository mockNotiRepo;
  late MockSupabaseDBCacher mockCacher;
  late StreamController<AuthState> authStreamController;
  late MockAppointmentSyncService mockSyncService;
  late MockSupabaseRTService mockSupabaseRTService;

  setUp(() {
    mockUsersRepo = MockUsersRepository();
    mockNotiRepo = MockNotificationsRepository();
    mockSyncService = MockAppointmentSyncService();

    mockAuth = MockSupabaseAuth();
    mockCacher = MockSupabaseDBCacher();
    authStreamController = StreamController<AuthState>.broadcast();
    mockSupabaseRTService = MockSupabaseRTService();
    

    container = ProviderContainer.test(
      overrides: [
        supabaseServiceProvider.overrideWithValue(MockSupabaseClient()),
        supabaseAuthProvider.overrideWithValue(mockAuth),
        usersRepositoryProvider.overrideWithValue(mockUsersRepo),
        notificationsRepositoryProvider.overrideWithValue(mockNotiRepo),
        supabaseDBCacherProvider.overrideWithValue(mockCacher),
        appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        supabaseRTServiceProvider.overrideWithValue(mockSupabaseRTService),
      ],
    );

    when(() => mockSyncService.syncClinics()).thenAnswer((_) async {});
    when(() => mockSyncService.syncServices()).thenAnswer((_) async {});
    when(() => mockSyncService.syncAppointments()).thenAnswer((_) async {});

    when(
      () => mockAuth.onAuthStateChange,
    ).thenAnswer((_) => authStreamController.stream);
    when(() => mockAuth.currentUser).thenReturn(null); // Start as guest

    when(() => mockNotiRepo.cleanupOldNotifications()).thenAnswer((_) async => 0);
  });

  tearDown(() {
    authStreamController.close();
  });

  test('Login as guest on initialization if no user exists', () async {
    when(() => mockCacher.cacheBroadcastNotifications(localId)).thenAnswer((_) async {});
    when(
      () => mockUsersRepo.getOrCreateGuest(),
    ).thenAnswer((_) async => testGuestAppUser);
    when(
      () => mockUsersRepo.updateLastLoginAndReturn(any()),
    ).thenAnswer((_) async => testGuestAppUser);

    final result = await container.read(appUserProvider.future);
    expect(result.localId, localId);
    verify(() => mockUsersRepo.getOrCreateGuest()).called(1);
  });

  test('Updates state when AuthChangeEvent.signedIn occurs', () async {
    final mockUser = MockUser();
    final mockSession = MockSession();

    when(() => mockUser.id).thenReturn(remoteId);
    when(() => mockSession.user).thenReturn(mockUser);
    when(() => mockAuth.currentUser).thenReturn(mockUser);

    when(
      () => mockUsersRepo.getOrInsertRegisteredUser(remoteId),
    ).thenAnswer((_) async => testRegisteredAppUser);
    when(
      () => mockUsersRepo.updateLastLoginAndReturn(localId),
    ).thenAnswer((_) async => testRegisteredAppUser);
    when(
      () => mockCacher.cacheRemoteToLocal(remoteId),
    ).thenAnswer((_) async {});
    when(
      () => mockSupabaseRTService.subscribeToAll(
        localId: localId,
        remoteId: remoteId,
      ),
    ).thenAnswer((_) async {});


    // Trigger build() for auth stream read
    await container.read(appUserProvider.future);
    authStreamController.add(AuthState(AuthChangeEvent.signedIn, mockSession));
    await pumpEventQueue();

    final state = container.read(appUserProvider).value;
    expect(state?.remoteId, remoteId);

    // Registered user is inserted
    verify(() => mockUsersRepo.getOrInsertRegisteredUser(remoteId)).called(1);

    // User last login updated
    verify(() => mockUsersRepo.updateLastLoginAndReturn(localId)).called(1);

    // Check if caching services called
    verify(() => mockCacher.cacheRemoteToLocal(remoteId)).called(1);
    verify(
      () => mockSupabaseRTService.subscribeToAll(
        localId: localId,
        remoteId: remoteId,
      ),
    ).called(1);
  });

  test('refreshLocalGuest recreates the guest user', () async {
    const newLocalId = 'newLocalId';
    when(() => mockUsersRepo.deleteGuestUser()).thenAnswer((_) async => {});
    when(
      () => mockUsersRepo.insertGuestUserAndReturn(),
    ).thenAnswer((_) async => testGuestAppUser.copyWith(localId: newLocalId));

    await container.read(appUserProvider.notifier).refreshLocalGuest();

    final result = await container.read(appUserProvider.future);
    expect(result.localId, newLocalId);
    verify(() => mockUsersRepo.deleteGuestUser()).called(1);
    verify(() => mockUsersRepo.insertGuestUserAndReturn()).called(1);
  });
}
