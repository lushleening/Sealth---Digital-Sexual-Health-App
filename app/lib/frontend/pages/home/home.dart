import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/articles/providers/recently_viewed_provider.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/home/home_data.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/recently_read.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/welcome_header.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeDataProvider);
    return AsyncPage(
      state: state,
      pageContent: (h) => _HomePageContent(data: h),
      logTextOnError: (e, _) => "Unable to generate home page: $e",
    );
  }
}

class _HomePageContent extends ConsumerWidget {
  final HomeData data;
  const _HomePageContent({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Home page generated.");

    final nextAppointment = data.appointments
        .where((a) => a.datetime.isAfter(DateTime.now()))
        .firstOrNull; // already sorted ascending

    // New articles: latest 5 (sorted newest-first from Supabase)
    final newArticles = data.articles.take(3).toList();

    // Recently viewed: articles the user has actually opened, in recency order
    final recentlyViewed = ref.watch(recentlyViewedProvider);
    final recentlyViewedArticles = recentlyViewed
        .map((id) => data.articles.where((a) => a.articleId == id).firstOrNull)
        .nonNulls
        .take(3)
        .toList();

    bool allNull =
        nextAppointment == null &&
        newArticles.isEmpty &&
        recentlyViewedArticles.isEmpty;

    return SafeContainer(
      child: Container(
        color: context.colors.grayBackground,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: WelcomeHeader(
                appName: data.appName,
                userContext: data.userContext,
              ),
            ),

            if (allNull)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "You're all done for now",
                    style: TextStyle(color: context.colors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            if (nextAppointment != null)
              SliverToBoxAdapter(
                child: UpcomingAppointments(appointment: nextAppointment),
              ),

            if (recentlyViewedArticles.isNotEmpty)
              SliverToBoxAdapter(
                child: RecentlyViewed(
                  articles: recentlyViewedArticles,
                ),
              ),

            if (newArticles.isNotEmpty)
              SliverToBoxAdapter(child: NewArticles(articles: newArticles)),
          ],
        ),
      ),
    );
  }
}
