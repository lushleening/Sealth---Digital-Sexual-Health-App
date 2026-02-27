import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';

// A safe container that ensures all buttons can be pressed by the user
class SafeContainer extends StatelessWidget {
  final Widget child;

  // {...} means named parameter, const improves speed as its determined in compile time
  const SafeContainer({
    super.key,
    this.child = const Scaffold(backgroundColor: Colors.transparent),
  });

  @override
  Widget build(BuildContext context) {
    // To color the phone's status bar (battery, wifi, time)
    // And prevent widgets from getting out of scope
    // An example child would be a "const Scaffold(backgroundColor: Colors.transparent)"
    return Container(
      color: context.colors.whiteBackground,
      child: SafeArea(child: child),
    );
  }
}
