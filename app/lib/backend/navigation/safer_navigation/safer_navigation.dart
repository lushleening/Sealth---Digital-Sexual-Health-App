import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/app_navigation_lock/app_navigation_lock.dart';
import 'package:sddp_dsh/backend/navigation/main_page_route/main_page_route.dart';

// Conducts a page switch to the respective main page,
// Then Navigation.push() to the subpage,
// Resulting in navigating back to their respective main page before going back to the home page
// Only works for indexed stack main navigation.
Future<void> dualNavPush(
  BuildContext context,
  WidgetRef ref, {
  required MainPageRoute toMainPage,
  Widget? toSubPage,
}) async {
  ref.read(mainPageRouteProvider.notifier).setPage(toMainPage);
  if (toSubPage != null) navPush(context, ref, toSubPage);
}

// A safer Navigator.push()
Future<void> navPush(
  BuildContext context,
  WidgetRef ref,
  Widget toSubPage,
) async {
  navLogger.info("navPush initiated");
  if (!context.mounted || ref.read(appNavigationLockProvider)) return;
  final lock = ref.read(appNavigationLockProvider.notifier);
  try {
    lock.lock();
    Navigator.push(context, MaterialPageRoute(builder: (_) => toSubPage));
  } catch (e) {
    navLogger.severe("An error occured at navPush: $e");
  } finally {
    lock.unlock();
  }
}

// A safer Navigator.pop()
Future<void> navPop(BuildContext context, WidgetRef ref) async {
  navLogger.info("navPop initiated");
  if (!Navigator.canPop(context) || ref.read(appNavigationLockProvider)) return;
  final lock = ref.read(appNavigationLockProvider.notifier);
  try {
    lock.lock();
    Navigator.pop(context);
  } catch (e) {
    navLogger.severe("An error occured at navPop: $e");
  } finally {
    lock.unlock();
  }
}
