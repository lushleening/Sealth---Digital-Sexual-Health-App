// Switches page based on AppStatus
import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/navigation/app_status/app_status.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/main_scaffold.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/login.dart';
import 'package:sddp_dsh/frontend/pages/loading/loading.dart';

Widget getHome(AppStatus status) {
  switch (status) {
    case AppStatus.loading:
      return const LoadingPage();
    case AppStatus.unauthenticated:
      return LoginPage(key: KPage.login.key);
    case AppStatus.authenticated:
      return const MainScaffold();
  }
}
