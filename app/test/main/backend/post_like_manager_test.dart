import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockDiscussionServices extends Mock implements DiscussionServices {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}

void main() {
  late MockDiscussionServices mockService;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late PostLikeManager likeManager;

  setUp(() {
    mockService = MockDiscussionServices();
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockService.supabase).thenReturn(mockSupabaseClient);
    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('test-user-id');
    when(() => mockService.isLiked(any())).thenAnswer((_) async => false);

    likeManager = PostLikeManager();
    likeManager.initialize(mockService);
  });

  group('PostLikeManager', () {
    test('getLikeInfo returns null before initialization', () {
      final info = likeManager.getLikeInfo('unknown-post');
      expect(info, isNull);
    });

    test('initializeLike sets correct initial state when not liked', () async {
      when(() => mockService.isLiked('post-1')).thenAnswer((_) async => false);
      await likeManager.initializeLike('post-1', 10);

      final info = likeManager.getLikeInfo('post-1');
      expect(info, isNotNull);
      expect(info!.isLiked, false);
      expect(info.likeCount, 10);
    });

    test('initializeLike sets correct state when already liked', () async {
      when(() => mockService.isLiked('post-2')).thenAnswer((_) async => true);
      await likeManager.initializeLike('post-2', 5);

      final info = likeManager.getLikeInfo('post-2');
      expect(info!.isLiked, true);
      expect(info.likeCount, 5);
    });

    test('toggleLike increments count when liking', () async {
      when(() => mockService.isLiked('post-1')).thenAnswer((_) async => false);
      when(() => mockService.toggleLike('post-1')).thenAnswer((_) async => true);

      await likeManager.initializeLike('post-1', 10);
      await likeManager.toggleLike('post-1');

      final info = likeManager.getLikeInfo('post-1');
      expect(info!.isLiked, true);
      expect(info.likeCount, 11);
    });

    test('toggleLike decrements count when unliking', () async {
      when(() => mockService.isLiked('post-1')).thenAnswer((_) async => true);
      when(() => mockService.toggleLike('post-1')).thenAnswer((_) async => false);

      await likeManager.initializeLike('post-1', 10);
      await likeManager.toggleLike('post-1');

      final info = likeManager.getLikeInfo('post-1');
      expect(info!.isLiked, false);
      expect(info.likeCount, 9);
    });

    test('toggleLike does nothing for unknown post', () async {
      // Should not throw
      await likeManager.toggleLike('unknown-post');
    });

    test('listener is notified on initializeLike', () async {
      when(() => mockService.isLiked('post-1')).thenAnswer((_) async => false);

      var notified = false;
      likeManager.addListener(() => notified = true);
      await likeManager.initializeLike('post-1', 5);

      expect(notified, true);
    });

    test('listener is notified on toggleLike', () async {
      when(() => mockService.isLiked('post-1')).thenAnswer((_) async => false);
      when(() => mockService.toggleLike('post-1')).thenAnswer((_) async => true);

      await likeManager.initializeLike('post-1', 5);

      var notified = false;
      likeManager.addListener(() => notified = true);
      await likeManager.toggleLike('post-1');

      expect(notified, true);
    });

    test('removeListener stops notifications', () async {
      when(() => mockService.isLiked('post-1')).thenAnswer((_) async => false);

      var notified = false;
      final listener = () => notified = true;
      likeManager.addListener(listener);
      likeManager.removeListener(listener);

      await likeManager.initializeLike('post-1', 5);
      expect(notified, false);
    });

    test('PostLikeInfo holds correct values', () {
      final info = PostLikeInfo(isLiked: true, likeCount: 42);
      expect(info.isLiked, true);
      expect(info.likeCount, 42);
    });

    test('initializeLike with null user skips isLiked check', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      // Should not call isLiked when user is null
      await likeManager.initializeLike('post-null-user', 3);

      final info = likeManager.getLikeInfo('post-null-user');
      expect(info!.isLiked, false);
      expect(info.likeCount, 3);
      verifyNever(() => mockService.isLiked('post-null-user'));
    });
  });
}