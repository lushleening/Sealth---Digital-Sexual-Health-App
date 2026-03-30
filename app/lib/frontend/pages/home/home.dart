import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/continue_reading.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/welcome_header.dart';

const dummyArticles = [
  Article(
    title: 'Understanding Sexual Health: A Comprehensive Guide',
    content: 'Learn about the importance of regular check-ups and maintaining good wellness in',
    linkToSubpage: SafeContainer(child: Text('Understanding Sexual Health')),
  ),
  Article(
    title: 'Breaking the Stigma: Mental Health and Sexual Wellness',
    content: 'Exploring the connection between mental wellbeing and sexual health in...',
    linkToSubpage: SafeContainer(child: Text('Breaking the Stigma')),
  ),
  Article(
    title: 'Pathway to Enlightment: Importance of Meditation and Routine',
    content: 'Understand the logic behind meditation and how it calms us down...',
    linkToSubpage: SafeContainer(child: Text('Pathway to Enlightment')),
  ),
];

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Home page generated.");
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
                    .firstOrNull;  // already sorted ascending
                if (next == null) return const SizedBox.shrink();
                return UpcomingAppointments(appointment: next);
              },
            ),

            ContinueReading(continueReadingArticles: dummyArticles),
            NewArticles(newArticles: dummyArticles),
          ],
        ),
      ),
    );
  }
}