import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';

class AddEventButton extends ConsumerWidget {
  const AddEventButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.mainColor,
          foregroundColor: context.colors.textWhite,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: () => context.push(AppRoute.addEvent),
        child: const Text("+ Add New Appointment"),
      ),
    );
  }
}
