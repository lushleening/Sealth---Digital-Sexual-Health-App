import 'package:flutter/material.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';

// Placeholder pages for the app, for development only
@Deprecated.instantiate("This is only a temporary widget and will be removed in the future")
class BlankPage extends StatelessWidget {
  final String string;
  const BlankPage({super.key, required this.string});
  @override
  Widget build(BuildContext context) => SafeContainer(child: Text(string));
}

@Deprecated.instantiate("This is only a temporary widget and will be removed in the future")
class BlankPageWithAppBar extends StatelessWidget {
  final String appBarString;
  const BlankPageWithAppBar({super.key, required this.appBarString});
  @override
  Widget build(BuildContext context) => SafeContainer(
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
