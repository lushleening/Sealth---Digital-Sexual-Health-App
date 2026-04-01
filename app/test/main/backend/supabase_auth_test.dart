import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/articles/providers/article_filter_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article_search_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/bookmarks_provider.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helper/mock_objects.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  late ProviderContainer container;
  late SupabaseClient mockClient;
  late MockGoTrueClient mockAuth;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockClient.auth).thenReturn(mockAuth);

    container = ProviderContainer.test(
      overrides: [supabaseServiceProvider.overrideWithValue(mockClient)],
    );

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test("registerEmailPassword calls Supabase's signUp function", () async {
    when(
      () => mockAuth.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => AuthResponse());

    await container
        .read(supabaseAuthProvider)
        .registerEmailPassword(mockEmail, mockPassword);

    verify(
      () => mockClient.auth.signUp(email: mockEmail, password: mockPassword),
    ).called(1);
  });

  test(
    "loginWithEmailPassword calls Supabase's signInWithPassword function",
    () async {
      when(
        () => mockAuth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => AuthResponse());

      await container
          .read(supabaseAuthProvider)
          .loginWithEmailPassword(mockEmail, mockPassword);

      verify(
        () => mockClient.auth.signInWithPassword(
          email: mockEmail,
          password: mockPassword,
        ),
      ).called(1);
    },
  );

  test("signInWithGoogle calls Supabase's signInWithOAuth function", () async {
    // Wrapper function for signInWithOAuth
    when(
      () => mockAuth.getOAuthSignInUrl(
        provider: OAuthProvider.google,
        redirectTo: any(named: 'redirectTo'),
      ),
    ).thenAnswer(
      (_) async => OAuthResponse(
        provider: OAuthProvider.google,
        url: 'https://example.com',
      ),
    );

    // For missing plugins
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/url_launcher'),
      (MethodCall methodCall) async {
        return true;
      },
    );

    await container.read(supabaseAuthProvider).signInWithGoogle();
    verify(
      () => mockAuth.getOAuthSignInUrl(
        provider: OAuthProvider.google,
        redirectTo: deepLinkLoginCallback,
      ),
    ).called(1);
  });

  test("signOut calls Supabase's signOut function", () async {
    when(() => mockAuth.signOut()).thenAnswer((_) async {});
    await container.read(supabaseAuthProvider).signOut();
    verify(() => mockClient.auth.signOut()).called(1);
  });

  test(
    "sendResetEmail calls Supabase's resetPasswordForEmail function",
    () async {
      when(
        () => mockAuth.resetPasswordForEmail(
          any(),
          redirectTo: deepLinkResetPassword,
        ),
      ).thenAnswer((_) => Future<void>.value());
      await container.read(supabaseAuthProvider).sendResetEmail(mockEmail);
      verify(() => mockClient.auth.resetPasswordForEmail(mockEmail)).called(1);
    },
  );

  test("resetPassword calls Supabase's updateUser function", () async {
    when(
      () => mockAuth.updateUser(UserAttributes(password: mockPassword)),
    ).thenAnswer((_) async => UserResponse.fromJson({}));

    await container
        .read(supabaseAuthProvider)
        .resetPassword(mockEmail, mockPassword);

    verify(
      () => mockClient.auth.updateUser(UserAttributes(password: mockPassword)),
    ).called(1);
  });

  test("toggleBookmark adds article when not bookmarked", () {
  final container = ProviderContainer();

  final article = Article(
    articleId: "1",
    authorId: "1",
    title: "Test",
    content: "Test content",
    image: "",
    markdownUrl: "",
    category: "General",
    linkToSubpage: const SizedBox(),
  );

  container.read(bookmarksProvider.notifier).toggleBookmark(article);

  final bookmarks = container.read(bookmarksProvider);

  expect(bookmarks.contains(article), true);
});

test("toggleBookmark removes article when already bookmarked", () {
  final container = ProviderContainer();

  final article = Article(
    articleId: "1",
    authorId: "1",
    title: "Test",
    content: "Test",
    image: "",
    markdownUrl: "",
    category: "General",
    linkToSubpage: const SizedBox(),
  );

  container.read(bookmarksProvider.notifier).toggleBookmark(article);
  container.read(bookmarksProvider.notifier).toggleBookmark(article);

  final bookmarks = container.read(bookmarksProvider);

  expect(bookmarks.isEmpty, true);
});

test("search provider updates query", () {
  final container = ProviderContainer();

  container.read(articleSearchProvider.notifier).setSearch("HIV");

  final query = container.read(articleSearchProvider);

  expect(query, "hiv");
});

test("filter provider updates category", () {
  final container = ProviderContainer();

  container.read(articleFilterProvider.notifier).setFilter("Testing");

  final filter = container.read(articleFilterProvider);

  expect(filter, "Testing");
});
}
