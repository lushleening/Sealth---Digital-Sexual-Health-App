import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/continue_reading.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/welcome_header.dart';

// TODO: Remove Dummy datas
final dummyAppointment = Appointment(
  name: 'Columbia Asia Hospital',
  description: 'Level 4, Room 3A',
  datetime: DateTime(2017, 9, 7, 17, 30),
  linkToSubpage: SafeContainer(child: Text("Columbia")),
);

const dummyArticles = [
  Article(
    title: 'Understanding Sexual Health: A Comprehensive Guide',
    content:
        'Learn about the importance of regular check-ups and maintaining good wellness in',
    linkToSubpage: SafeContainer(child: Text('Understanding Sexual Health')),
  ),
  Article(
    title: 'Breaking the Stigma: Mental Health and Sexual Wellness',
    content:
        'Exploring the connection between mental wellbeing and sexual health in...',
    linkToSubpage: SafeContainer(child: Text('Breaking the Stigma')),
  ),
  Article(
    title: 'Pathway to Enlightment: Importance of Meditation and Routine',
    content:
        'Understand the logic behind meditation and how it calms us down...',
    linkToSubpage: SafeContainer(child: Text('Pathway to Enlightment')),
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Home page generated.");
    return SafeContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Separating widgets into sections
            WelcomeHeader(),
            UpcomingAppointments(appointment: dummyAppointment),
            ContinueReading(continueReadingArticles: dummyArticles),
            NewArticles(newArticles: dummyArticles),
          ],
        ),
      ),
    );
  }
}
