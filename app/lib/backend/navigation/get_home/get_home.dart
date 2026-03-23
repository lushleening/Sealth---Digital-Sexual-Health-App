// Switches page based on AppStatus
import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/navigation/app_status/app_status.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/main_scaffold.dart';
import 'package:sddp_dsh/frontend/pages/loading/loading.dart';

Widget getHome(AppStatus status) {
  switch (status) {
    case AppStatus.loading:
      return const LoadingPage();
    case AppStatus.authenticated:
      return const MainScaffold();
    case AppStatus.error:
      return BlankPageWithError();
  }
}
