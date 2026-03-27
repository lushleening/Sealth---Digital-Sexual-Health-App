import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/navigation/app_status/app_status.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/blank/blank_pages.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/main_scaffold.dart';
import 'package:sddp_dsh/frontend/pages/appointments/appointments.dart';
import 'package:sddp_dsh/frontend/pages/articles/articles.dart';
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

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final navRouter = Provider<GoRouter>((ref) {
  final status = ref.watch(appStatusProvider);

  return GoRouter(
    navigatorKey:
        rootNavigatorKey, // Use this to remove bottomNavBar in places where it shouldn't exist
    initialLocation: '/',
    redirect:
        (
          context,
          state,
        ) => // Force to loading / error page if not authenticated
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
                            routes: [],
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
                    path: 'details/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'];
                      // TODO: Parse in your edit appointments page
                      return BlankPageWithAppBar(appBarString: id!);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              // TODO: Apparently you can do something like `context.go('/appointments?sort=date&filter=upcoming');`
              // TODO: Would be helpful for articles I think
              GoRoute(
                path: '/articles',
                builder: (context, state) =>
                    ArticlesPage(key: KPage.article.key),
                routes: [
                  GoRoute(
                    path: 'details/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'];
                      // TODO: Parse in your edit appointments page
                      return BlankPageWithAppBar(appBarString: id!);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoute.resetPassword,
        builder: (context, state) => ResetPasswordPage(),
      ),

      GoRoute(
        path: AppRoute.resetLogin,
        builder: (context, state) => LoginPage(),
      ),
    ],
  );
});
