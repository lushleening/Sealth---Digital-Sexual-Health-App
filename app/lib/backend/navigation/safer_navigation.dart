import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Conducts a page switch to the respective main page,
// Then Navigation.push() to the subpage,
// Resulting in navigating back to their respective main page before going back to the home page
// Only works for indexed stack main navigation.

// For teammates to phase out their navigation logics smoother
@Deprecated(
  "NOTE: This function is deprecated and will be removed in the next deliverable. Use context.go(path) instead.",
)
Future<void> navPush(
  BuildContext context,
  WidgetRef ref,
  Widget toSubPage,
) async {
  Navigator.push(context, MaterialPageRoute(builder: (_) => toSubPage));
}

// For teammates to phase out their navigation logics smoother
@Deprecated(
  "NOTE: This function is deprecated and will be removed in the next deliverable. Use context.pop() instead.",
)
Future<void> navPop(BuildContext context, WidgetRef ref) async {
  Navigator.pop(context);
}
