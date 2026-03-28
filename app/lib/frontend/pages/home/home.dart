import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/continue_reading.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/welcome_header.dart';

// TODO: Remove dummy appointment when appointments are implemented
final dummyAppointment = Appointment(
  name: 'Columbia Asia Hospital',
  description: 'Level 4, Room 3A',
  datetime: DateTime(2017, 9, 7, 17, 30),
  linkToSubpage: SafeContainer(child: Text("Columbia")),
);

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

    return SafeContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeHeader(),
            UpcomingAppointments(appointment: dummyAppointment),
            ContinueReading(continueReadingArticles: continueReadingArticles),
            NewArticles(newArticles: newArticles),
          ],
        ),
      ),
    );
  }
}