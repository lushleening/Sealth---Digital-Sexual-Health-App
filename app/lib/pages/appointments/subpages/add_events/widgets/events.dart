import 'package:flutter/material.dart';
import 'package:sddp_dsh/objects/appointment.dart';
import 'package:sddp_dsh/helper/colors.dart';

class EventsPage extends StatefulWidget {
  final List<Appointment> events;

  const EventsPage({required this.events, super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String? _selectedAppointmentType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedLocation;
  final TextEditingController _notesController = TextEditingController();

  List<String> get _appointmentTypes =>
      widget.events.map((e) => e.description).toSet().toList();

  List<String> get _locations =>
      widget.events.map((e) => e.name).toSet().toList();

  InputDecoration _fieldDecoration(BuildContext context, {Widget? prefixIcon}) {
    final c = context.colors;
    return InputDecoration(
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: c.whiteBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c.buttonBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c.buttonBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c.mainColor, width: 1.5),
      ),
    );
  }

  Widget _label(BuildContext context, String text, {bool required = true}) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: c.textPrimary,
          ),
          children: required
              ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: c.warning),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: context.colors.mainColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: context.colors.mainColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(context, 'Appointment Type'),
        DropdownButtonFormField<String>(
          initialValue: _selectedAppointmentType,
          hint: Text(
            'Select appointment type',
            style: TextStyle(color: c.textSecondary, fontSize: 14),
          ),
          decoration: _fieldDecoration(context),
          items: _appointmentTypes
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (val) => setState(() => _selectedAppointmentType = val),
        ),

        const SizedBox(height: 18),

        _label(context, 'Date'),
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextFormField(
              decoration:
                  _fieldDecoration(
                    context,
                    prefixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: c.textSecondary,
                      size: 18,
                    ),
                  ).copyWith(
                    hintText: 'dd/mm/yyyy',
                    hintStyle: TextStyle(color: c.textSecondary, fontSize: 14),
                  ),
              controller: TextEditingController(
                text: _selectedDate == null
                    ? ''
                    : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                          '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                          '${_selectedDate!.year}',
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        _label(context, 'Time'),
        GestureDetector(
          onTap: _pickTime,
          child: AbsorbPointer(
            child: TextFormField(
              decoration:
                  _fieldDecoration(
                    context,
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: c.textSecondary,
                      size: 18,
                    ),
                  ).copyWith(
                    hintText: 'Select time',
                    hintStyle: TextStyle(color: c.textSecondary, fontSize: 14),
                  ),
              controller: TextEditingController(
                text: _selectedTime == null
                    ? ''
                    : _selectedTime!.format(context),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        _label(context, 'Location'),
        DropdownButtonFormField<String>(
          initialValue: _selectedLocation,
          hint: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: c.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Select location',
                style: TextStyle(color: c.textSecondary, fontSize: 14),
              ),
            ],
          ),
          decoration: _fieldDecoration(context),
          items: _locations
              .map((l) => DropdownMenuItem(value: l, child: Text(l)))
              .toList(),
          onChanged: (val) => setState(() => _selectedLocation = val),
        ),

        const SizedBox(height: 18),

        _label(context, 'Notes (Optional)', required: false),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          decoration:
              _fieldDecoration(
                context,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.note_outlined, size: 18),
                ),
              ).copyWith(
                hintText: 'Add any additional notes...',
                hintStyle: TextStyle(color: c.textSecondary, fontSize: 14),
              ),
        ),
      ],
    );
  }
}
