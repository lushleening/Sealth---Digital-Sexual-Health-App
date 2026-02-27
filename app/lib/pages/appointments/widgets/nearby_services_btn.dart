import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/pages/appointments/subpages/nearby_services/nearby_services.dart';

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
        onPressed: () {
          navPush(context, ref, const NearbyServicesPage());
        },
        child: const Text("View Nearby Services"),
      ),
    );
  }
}
