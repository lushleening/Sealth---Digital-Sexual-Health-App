import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';

class AppointmentsFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String?> onChanged;

  const AppointmentsFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: c.whiteBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: c.whiteBackground.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButton<String>(
          value: selectedFilter,
          items: const [
            DropdownMenuItem(value: "Upcoming", child: Text("Upcoming")),
            DropdownMenuItem(value: "Today", child: Text("Today")),
            DropdownMenuItem(value: "All", child: Text("All")),
          ],
          onChanged: onChanged,
          style: TextStyle(color: c.textPrimary, fontSize: 14),
          underline: Container(), // removes default underline
          icon: Icon(Icons.arrow_drop_down, color: c.textPrimary),
        ),
      ),
    );
  }
}
