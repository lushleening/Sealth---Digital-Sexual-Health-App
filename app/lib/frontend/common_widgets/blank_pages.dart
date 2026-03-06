import 'package:flutter/material.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';

// Placeholder pages for the app
Widget blankPage(String str) {
  return SafeContainer(child: Text(str));
}

Widget blankPageWithAppBar(BuildContext context, String appBarString) {
  return SafeContainer(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: TopAppBar(
        title: appBarString,
        fg: context.colors.textPrimary,
        bg: context.colors.whiteBackground,
      ),
    ),
  );
}
