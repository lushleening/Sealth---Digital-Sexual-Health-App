import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';

class NearbyServicesButton extends ConsumerWidget {
  const NearbyServicesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.mainColor,
          foregroundColor: context.colors.textWhite,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: () => context.push(AppRoute.nearbyServices),
        child: const Text("View Nearby Services"),
      ),
    );
  }
}
