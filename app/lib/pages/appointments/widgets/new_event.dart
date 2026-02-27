import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/pages/appointments/subpages/add_events/add_events.dart';

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
        onPressed: () {
          navPush(context, ref, const AddEventPage());
        },
        child: const Text("+ Add New Event"),
      ),
    );
  }
}
