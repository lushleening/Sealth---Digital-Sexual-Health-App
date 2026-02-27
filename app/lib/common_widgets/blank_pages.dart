import 'package:flutter/material.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/helper/colors.dart';

// Placeholder pages
Widget blankPage(String str) {
  return SafeContainer(child: Text(str));
}

// Placeholder pages
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
