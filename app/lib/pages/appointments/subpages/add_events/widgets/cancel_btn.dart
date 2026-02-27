import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';

class Cancelbtn extends StatelessWidget {
  final VoidCallback onPressed;
  const Cancelbtn({required this.onPressed, super.key});

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
            backgroundColor: context.colors.grayBackground,
            foregroundColor: context.colors.textSecondary,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 20), // only vertical
          ),
          onPressed: onPressed,
          child: const Text("Cancel"),
        ),
      ),
    );
  }
}
