import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

// A top app bar that has a back button to navigate between pages
// Use this on navPush'ed pages
class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color fg;
  final Color bg;

  const TopAppBar({
    super.key,
    required this.title,
    required this.fg,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Top appbar is generated");
    return Padding(
      padding: EdgeInsetsGeometry.directional(top: 16),
      child: AppBar(
        title: Text(title),
        leading: context.canPop()
            ? IconButton(
                key: KBtn.navBackButton.key,
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back),
              )
            : null,
        centerTitle: true,
        foregroundColor: fg,
        backgroundColor: bg,

        // Remove darkening on scroll
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
