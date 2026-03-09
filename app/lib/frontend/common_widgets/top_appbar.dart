import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

// A top app bar that has a back button to navigate between pages
// Use this on navPush'ed pages
class TopAppBar extends ConsumerWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Top appbar is generated");
    return Padding(
      padding: EdgeInsetsGeometry.directional(top: 16),
      child: AppBar(
        title: Text(title),
        leading: Navigator.canPop(context)
            ? IconButton(
                key: KBtn.backButton.key,
                onPressed: () => navPop(context, ref),
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
