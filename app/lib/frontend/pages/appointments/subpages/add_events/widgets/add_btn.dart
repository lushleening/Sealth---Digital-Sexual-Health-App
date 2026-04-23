import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.mainColor,
            foregroundColor: context.colors.textWhite,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          onPressed: onPressed,
          child: const Text("Add Appointment"),
        ),
      ),
    );
  }
}