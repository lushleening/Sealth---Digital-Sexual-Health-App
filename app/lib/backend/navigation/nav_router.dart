import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/app_status/app_status.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/main_scaffold.dart';
import 'package:sddp_dsh/frontend/pages/appointments/appointments.dart';
import 'package:sddp_dsh/frontend/pages/articles/articles.dart';
import 'package:sddp_dsh/frontend/pages/articles/bookmarks.dart';
import 'package:sddp_dsh/frontend/pages/articles/edit_article.dart';
import 'package:sddp_dsh/frontend/pages/articles/markdown_article_page.dart';
import 'package:sddp_dsh/frontend/pages/articles/upload_article.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion.dart';
import 'package:sddp_dsh/frontend/pages/home/home.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/notifications/notifications.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/profile.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/login.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/forgot_password/forgot_password.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/forgot_password/subpages/reset_password.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/register/register.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/personal_info.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/settings.dart';
import 'package:sddp_dsh/frontend/common_widgets/loading.dart';
import 'package:sddp_dsh/frontend/pages/discussion/create_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/my_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/edit_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/blocked_users_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/reported_posts_page.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/add_events/add_events.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/edit_events.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/nearby_services/nearby_services.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final navRouter = Provider<GoRouter>((ref) {
  final status = ref.watch(appStatusProvider);

  final auth = ref.watch(supabaseAuthProvider);
  auth.listenToRecovery((email) {
    authLogger.info("Password reset initiated");
    rootNavigatorKey.currentState?.context.go(
      AppRoute.resetPassword,
      extra: email,
    );
  });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) =>
        status != AppStatus.authenticated && state.matchedLocation != '/'
        ? '/'
        : null,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          switch (status) {
            case AppStatus.loading:
              return const LoadingPage();
            case AppStatus.error:
              return const BlankPageWithError();
            case AppStatus.authenticated:
              return const LoadingPage();
          }
        },
        redirect: (context, state) =>
            status == AppStatus.authenticated ? '/home' : null,
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) => MainScaffold(navShell: navShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: AppRoute.profileR,
                    builder: (context, state) => const ProfilePage(),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: rootNavigatorKey,
                        path: AppRoute.personalInfoR,
                        builder: (context, state) => const PersonalInfoPage(),
                        routes: [
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            path: AppRoute.changePasswordR,
                            builder: (context, state) => ResetPasswordPage(
                              email: state.extra as String,
                              loggedIn: true,
                            ),
                          ),
                        ],
                      ),
                      GoRoute(
                        parentNavigatorKey: rootNavigatorKey,
                        path: AppRoute.settingsR,
                        builder: (context, state) => const SettingsPage(),
                      ),
                      GoRoute(
                        parentNavigatorKey: rootNavigatorKey,
                        path: AppRoute.loginR,
                        builder: (context, state) => const LoginPage(),
                        routes: [
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            path: AppRoute.registerR,
                            builder: (context, state) => const RegisterPage(),
                          ),
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            path: AppRoute.forgotPasswordR,
                            builder: (context, state) =>
                                const ForgotPasswordPage(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: AppRoute.notificationsR,
                    builder: (context, state) => const NotificationsPage(),
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discussion',
                builder: (context, state) =>
                    DiscussionPage(key: KPage.discussion.key),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreatePostPage(),
                  ),
                  GoRoute(
                    path: 'post',
                    builder: (context, state) {
                      final post = state.extra as DiscussionPost;
                      return DiscussionPostPage(post: post);
                    },
                  ),
                  GoRoute(
                    path: 'my-posts',
                    name: 'myPosts',
                    builder: (context, state) => const MyPostsPage(),
                  ),
                  GoRoute(
                    path: 'edit-post',
                    name: 'discussionEditPost',
                    builder: (context, state) {
                      final post = state.extra as DiscussionPost;
                      return EditPostPage(post: post);
                    },
                  ),
                  GoRoute(
                    path: 'blocked-users',
                    name: 'blockedUsers',
                    builder: (context, state) => const BlockedUsersPage(),
                  ),
                  GoRoute(
                    path: 'reported-posts',
                    name: 'reportedPosts',
                    builder: (context, state) => const ReportedPostsPage(),
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/appointments',
                builder: (context, state) =>
                    AppointmentsPage(key: KPage.appointment.key),
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: AppRoute.addEventR,
                    builder: (context, state) {
                      final clinicId = state.extra as String?;
                      return AddEventPage(preselectedClinicId: clinicId);
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: AppRoute.editEventsR,
                    builder: (context, state) {
                      final appointment = state.extra as Appointment;
                      return EditEvents(appointment: appointment);
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: AppRoute.nearbyServicesR,
                    builder: (context, state) => const NearbyServicesPage(),
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.articles,
                builder: (context, state) =>
                    ArticlesPage(key: KPage.article.key),
                routes: [
                  // View article
                  GoRoute(
                    path: AppRoute.articleViewR,
                    builder: (context, state) {
                      final args = state.extra as Map<String, dynamic>;
                      return MarkdownArticlePage(
                        article: args['article'] as Article,
                        category: args['category'] as String,
                        markdownUrl: args['markdownUrl'] as String,
                        thumbnailUrl: args['thumbnailUrl'] as String,
                        markdownPath: args['markdownUrl'] as String,
                      );
                    },
                  ),

                  // Upload article
                  GoRoute(
                    path: AppRoute.articleUploadR,
                    builder: (context, state) =>
                        UploadArticlePage(key: KPage.uploadArticle.key),
                  ),

                  // Edit article
                  GoRoute(
                    path: AppRoute.articleEditR,
                    builder: (context, state) {
                      final args = state.extra as Map<String, dynamic>;
                      return EditArticlePage(
                        article: args['article'] as Article,
                        category: args['category'] as String,
                        markdownUrl: args['markdownUrl'] as String,
                        thumbnailUrl: args['thumbnailUrl'] as String,
                      );
                    },
                  ),

                  // Bookmarks
                  GoRoute(
                    path: AppRoute.articleBookmarksR,
                    builder: (context, state) =>
                        BookmarksPage(key: KPage.bookmarks.key),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoute.resetPassword,
        builder: (context, state) =>
            ResetPasswordPage(email: state.extra as String, loggedIn: false),
      ),

      GoRoute(
        path: AppRoute.resetLogin,
        builder: (context, state) => LoginPage(),
      ),
    ],
  );
});
