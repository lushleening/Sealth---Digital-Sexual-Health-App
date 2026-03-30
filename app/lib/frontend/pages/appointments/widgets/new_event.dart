import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';

class AddEventButton extends ConsumerWidget {
  const AddEventButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.mainColor, // teal background
          foregroundColor: context.colors.textWhite, // white text
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: () => context.push(AppRoute.addEvent),
        child: const Text("+ Add New Appointment"),
      ),
    );
  }
}
