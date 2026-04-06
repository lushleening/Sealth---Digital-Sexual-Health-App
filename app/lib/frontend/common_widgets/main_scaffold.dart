import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:flutter/material.dart';

final navBarItems = [
  BottomNavigationBarItem(
    key: KBtn.navHomeBottom.key,
    icon: Icon(Icons.home_outlined),
    label: "Home",
  ),
  BottomNavigationBarItem(
    key: KBtn.navDiscussionBottom.key,
    icon: Icon(Icons.chat_bubble_outline),
    label: "Discussion",
  ),
  BottomNavigationBarItem(
    key: KBtn.navAppointmentBottom.key,
    icon: Icon(Icons.calendar_month_outlined),
    label: "Appointment",
  ),
  BottomNavigationBarItem(
    key: KBtn.navArticleBottom.key,
    icon: Icon(Icons.article_outlined),
    label: "Articles",
  ),
];

// Implements a bottom Navigation Bar for all main pages (check nav_router for more info)
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navShell;
  const MainScaffold({super.key, required this.navShell});

  void _onTap(int index) =>
      navShell.goBranch(index, initialLocation: index == navShell.currentIndex);

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Building main scaffold with bottom navigation bar");
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) async {
        if (navShell.currentIndex != 0) {
          // 0 for HomePage
          uiLogger.finer("Back button pressed, going to home page...");
          _onTap(0);
        } else {
          final bool? quit = await showDialog<bool>(
            context: context,
            builder: (_) => ChoiceDialog(
              title: "Quit",
              content: "Are you sure to quit?",
              yesStyle: TextStyle(color: context.colors.alert),
            ),
          );
          if (quit == true) await FlutterExitApp.exitApp();
        }
      },
      child: Scaffold(
        body: navShell,
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
            currentIndex: navShell.currentIndex,
            onTap: _onTap,
            items: navBarItems,
          ),
        ),
      ),
    );
  }
}
