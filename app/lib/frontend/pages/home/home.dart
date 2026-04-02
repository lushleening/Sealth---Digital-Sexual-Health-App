import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
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
    uiLogger.finer("Home page generated.");

    final allArticles = ref.watch(articlesProvider);

    // Extract just the Article objects from the provider state
    final articles = allArticles
        .map((data) => data["article"] as Article)
        .toList();

    // Show latest 3 for both sections
    final newArticles = articles.take(3).toList();
    final continueReadingArticles = articles.take(3).toList();
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    return SafeContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeHeader(),

            appointmentsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Could not load appointment: $e'),
              ),
              data: (appointments) {
                final now = DateTime.now();
                final next = appointments
                    .where((a) => a.datetime.isAfter(now))
                    .firstOrNull; // already sorted ascending
                if (next == null) return const SizedBox.shrink();
                return UpcomingAppointments(appointment: next);
              },
            ),

            ContinueReading(continueReadingArticles: continueReadingArticles),
            NewArticles(newArticles: newArticles),
          ],
        ),
      ),
    );
  }
}
