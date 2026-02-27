import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/nav/main_page_route.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/pages/appointments/appointments.dart';
import 'package:sddp_dsh/pages/articles/articles.dart';
import 'package:sddp_dsh/pages/discussion/discussion.dart';
import 'package:sddp_dsh/pages/home/home.dart';

// TODO: Some page links require parsing in parameters [still thinking how to do it, but should be sth like adding a fn on ur side

// Bottom navigation buttons
final List<Widget> pages = [
  HomePage(key: MainPageRoute.home.to.key),
  DiscussionPage(key: MainPageRoute.discussion.to.key),
  AppointmentsPage(key: MainPageRoute.appointment.to.key),
  ArticlesPage(key: MainPageRoute.article.to.key),
];

// Implements a bottom Navigation Bar for all main pages (declared by variable pages above)
class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    uiLogger.info("Building main scaffold with bottom navigation bar");
    final page = ref.watch(mainPageRouteProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (page.index != MainPageRoute.home.index) {
          uiLogger.fine("Back button pressed, going to home page...");
          ref.read(mainPageRouteProvider.notifier).setPage(MainPageRoute.home);
        } else {
          final bool? quit = await showDialog<bool>(
            context: context,
            builder: (_) => const ChoiceDialog(
              title: "Quit",
              content: "Are you sure to quit?",
            ),
          );
          if (quit == true) await FlutterExitApp.exitApp();
        }
      },
      child: Scaffold(
        body: IndexedStack(index: page.index, children: pages),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: context.colors.mainColor.withValues(alpha: 0.1),
            highlightColor: context.colors.mainColor.withValues(
              alpha: buttonOverlayAlpha,
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: context.colors.whiteBackground,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: context.colors.mainColor,
            unselectedItemColor: context.colors.textSecondary,
            currentIndex: page.index,
            onTap: (index) => ref
                .read(mainPageRouteProvider.notifier)
                .setPage(MainPageRoute.values[index]),
            items: [
              BottomNavigationBarItem(
                key: KBtn.homeBottomNav.key,
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                key: KBtn.discussionBottomNav.key,
                icon: Icon(Icons.chat_bubble_outline),
                label: "Discussion",
              ),
              BottomNavigationBarItem(
                key: KBtn.appointmentBottomNav.key,
                icon: Icon(Icons.calendar_month_outlined),
                label: "Appointment",
              ),
              BottomNavigationBarItem(
                key: KBtn.articleBottomNav.key,
                icon: Icon(Icons.article_outlined),
                label: "Articles",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO guest reminder bar?
