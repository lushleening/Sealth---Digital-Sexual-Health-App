import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sddp_dsh/objects/appointment.dart';
import 'package:sddp_dsh/helper/colors.dart';

class CalendarPage extends StatefulWidget {
  final List<Appointment> calendarView;

  const CalendarPage({required this.calendarView, super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: (day) {
            return widget.calendarView
                .where((a) => isSameDay(a.datetime, day))
                .toList();
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: context.colors.textPrimary,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: context.colors.textPrimary,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: context.colors.mainColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            weekendStyle: TextStyle(
              color: context.colors.mainColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: context.colors.mainColor,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: context.colors.textWhite,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              color: context.colors.mainColor,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: context.colors.textWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
