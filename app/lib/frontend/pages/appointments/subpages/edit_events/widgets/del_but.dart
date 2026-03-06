import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';

class Deletebtn extends StatelessWidget {
  final VoidCallback onPressed;
  const Deletebtn({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            MediaQuery.of(context).size.width * 0.05, // 5% gap each side
      ),
      child: SizedBox(
        width: double.infinity, // fills remaining width
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.alert,
            foregroundColor: context.colors.whiteBackground,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 20), // only vertical
          ),
          onPressed: onPressed,
          child: const Text("Delete Appointment"),
        ),
      ),
    );
  }
}
