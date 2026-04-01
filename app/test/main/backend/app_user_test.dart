import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_cacher.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helper/mock_objects.dart';

class MockSupabaseAuth extends Mock implements SupabaseAuth {}

class MockUsersRepository extends Mock implements UsersRepository {}

class MockSupabaseDBCacher extends Mock implements SupabaseDBCacher {}

class MockUser extends Mock implements User {}

class MockSession extends Mock implements Session {}

class MockUserRepository extends Mock implements UsersRepository {}

void main() {
  late ProviderContainer container;
  late MockSupabaseAuth mockAuth;
  late MockUsersRepository mockRepo;
  late MockSupabaseDBCacher mockCacher;
  late StreamController<AuthState> authStreamController;

  setUp(() {
    mockAuth = MockSupabaseAuth();
    mockRepo = MockUsersRepository();
    mockCacher = MockSupabaseDBCacher();
    authStreamController = StreamController<AuthState>.broadcast();

    container = ProviderContainer.test(
      overrides: [
        supabaseAuthProvider.overrideWithValue(mockAuth),
        usersRepositoryProvider.overrideWithValue(mockRepo),
        supabaseDBCacherProvider.overrideWithValue(mockCacher),
      ],
    );

    when(
      () => mockAuth.onAuthStateChange,
    ).thenAnswer((_) => authStreamController.stream);
    when(() => mockAuth.currentUser).thenReturn(null); // Start as guest
  });

  tearDown(() {
    authStreamController.close();
  });

  test('Login as guest on initialization if no user exists', () async {
    when(
      () => mockRepo.getOrCreateGuest(),
    ).thenAnswer((_) async => testGuestAppUser);
    when(
      () => mockRepo.updateLastLoginAndReturn(any()),
    ).thenAnswer((_) async => testGuestAppUser);
    final result = await container.read(appUserProvider.future);
    expect(result.localId, localId);
    verify(() => mockRepo.getOrCreateGuest()).called(1);
  });

  test('Updates state when AuthChangeEvent.signedIn occurs', () async {
    final mockUser = MockUser();
    final mockSession = MockSession();

    when(() => mockUser.id).thenReturn(remoteId);
    when(() => mockSession.user).thenReturn(mockUser);

    when(
      () => mockRepo.getOrInsertRegisteredUser(remoteId),
    ).thenAnswer((_) async => testRegisteredAppUser);
    when(
      () => mockRepo.updateLastLoginAndReturn(localId),
    ).thenAnswer((_) async => testRegisteredAppUser);
    when(
      () => mockCacher.cacheRemoteToLocal(remoteId),
    ).thenAnswer((_) async => {});

    // Trigger build() for auth stream read
    container.read(appUserProvider);
    authStreamController.add(AuthState(AuthChangeEvent.signedIn, mockSession));
    await Future.delayed(Duration.zero); // Wait for auth stream

    final state = container.read(appUserProvider).value;
    expect(state?.remoteId, remoteId);
    verify(() => mockCacher.cacheRemoteToLocal(remoteId)).called(1);
  });

  test('refreshLocalGuest recreates the guest user', () async {
    const newLocalId = 'newLocalId';
    when(() => mockRepo.deleteGuestUser()).thenAnswer((_) async => {});
    when(
      () => mockRepo.insertGuestUserAndReturn(),
    ).thenAnswer((_) async => testGuestAppUser.copyWith(localId: newLocalId));

    await container.read(appUserProvider.notifier).refreshLocalGuest();

    final result = await container.read(appUserProvider.future);
    expect(result.localId, newLocalId);
    verify(() => mockRepo.deleteGuestUser()).called(1);
    verify(() => mockRepo.insertGuestUserAndReturn()).called(1);
  });
}
