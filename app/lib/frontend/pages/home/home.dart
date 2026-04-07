import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/home/home_data.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/continue_reading.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
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

    final next = data.appointments
        .where((a) => a.datetime.isAfter(DateTime.now()))
        .firstOrNull; // already sorted ascending

    // Show latest 3 for both sections
    final newArticles = data.articles.take(3).toList();
    final continueReadingArticles = data.articles.take(3).toList();

    return SafeContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeHeader(appName: data.appName, userContext: data.userContext),
            next == null
                ? const SizedBox.shrink()
                : UpcomingAppointments(appointment: next),
            ContinueReading(continueReadingArticles: continueReadingArticles),
            NewArticles(newArticles: newArticles),
          ],
        ),
      ),
    );
  }
}
