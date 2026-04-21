import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';

class EventsPage extends ConsumerStatefulWidget {
  final String? preselectedClinicId;
  final void Function({
    required String clinicId,
    required String serviceId,
    required DateTime dateTime,
    String? notes,
  }) onChanged;
  final void Function(VoidCallback submitFn)? onSubmitReady;

  const EventsPage({
    required this.onChanged,
    this.preselectedClinicId,
    this.onSubmitReady,
    super.key,
  });

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  String? selectedClinicId;
  String? selectedServiceId;
  DateTime? selectedDateTime;

  late final TextEditingController notesController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    selectedClinicId = widget.preselectedClinicId;

    notesController = TextEditingController();
    _dateController = TextEditingController();
    _timeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSubmitReady?.call(submit);
    });
  }

  @override
  void dispose() {
    notesController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Theme _pickerTheme(BuildContext context, Widget child) {
    final c = context.colors;

    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogThemeData(
          backgroundColor: c.whiteBackground
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: c.mainColor,
          onPrimary: c.textWhite,
          secondary: c.mainColor, 
          onSecondary: c.textWhite,
          surface: c.whiteBackground,
          onSurface: c.textPrimary,
        ),

        datePickerTheme: DatePickerThemeData(
        backgroundColor: c.whiteBackground,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: c.mainColor,
        headerForegroundColor: c.textWhite,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return c.textWhite;
          }
          return c.textPrimary;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return c.mainColor;
          }
          return null;
        }),
      ),

        timePickerTheme: TimePickerThemeData(
          backgroundColor: c.whiteBackground,
          dialBackgroundColor: c.grayBackground,
          dialHandColor: c.mainColor,
          hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return c.textWhite; // text on mainColor
            }
            return c.textPrimary; // normal text
          }),
          hourMinuteColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return c.mainColor;
            }
            return c.grayBackground; // inactive
          }),
          dayPeriodTextColor: c.textPrimary,
          dayPeriodColor: c.mainColor,
          entryModeIconColor: c.mainColor,
        ),
      ),
      child: child,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => _pickerTheme(context, child!),
    );

    if (picked != null) {
      setState(() {
        selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedDateTime?.hour ?? 0,
          selectedDateTime?.minute ?? 0,
        );

        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedDateTime != null
          ? TimeOfDay(
              hour: selectedDateTime!.hour,
              minute: selectedDateTime!.minute,
            )
          : TimeOfDay.now(),
      builder: (context, child) => _pickerTheme(context, child!),
    );

    if (picked != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime?.year ?? DateTime.now().year,
          selectedDateTime?.month ?? DateTime.now().month,
          selectedDateTime?.day ?? DateTime.now().day,
          picked.hour,
          picked.minute,
        );

        _timeController.text = picked.format(context);
      });
    }
  }

  InputDecoration _fieldDecoration(BuildContext context, {Widget? prefixIcon}) {
    final c = context.colors;

    return InputDecoration(
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: c.whiteBackground,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

  Widget _label(BuildContext context, String text,
      {bool required = true}) {
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
                    style: TextStyle(color: c.alert),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  void submit() {
    if (selectedClinicId != null &&
        selectedServiceId != null &&
        selectedDateTime != null) {
      widget.onChanged(
        clinicId: selectedClinicId!,
        serviceId: selectedServiceId!,
        dateTime: selectedDateTime!,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );
    } else {
      showSnackbarMessage('Please fill in all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinicsAsync = ref.watch(clinicsProvider);
    final servicesAsync = selectedClinicId != null
        ? ref.watch(servicesProvider(selectedClinicId!))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(context, 'Location'),
        clinicsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error loading clinics: $e'),
          data: (clinics) => DropdownButtonFormField<String>(
            dropdownColor: context.colors.whiteBackground,
            initialValue: selectedClinicId,
            hint: Text(
              'Select location',
              style: TextStyle(color: context.colors.textSecondary),
            ),
            decoration: _fieldDecoration(context),
            items: clinics
                .map(
                  (c) => DropdownMenuItem<String>(
                    value: c['id']?.toString(),
                    child: Text(c['name']?.toString() ?? ''),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() {
              selectedClinicId = val;
              selectedServiceId = null;
            }),
          ),
        ),

        const SizedBox(height: 18),

        if (selectedClinicId != null && servicesAsync != null)
          servicesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error loading services: $e'),
            data: (services) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(context, 'Appointment Type'),
                DropdownButtonFormField<String>(
                  initialValue: selectedServiceId,
                  dropdownColor: context.colors.whiteBackground,
                  hint: Text(
                    'Select appointment type',
                    style:
                        TextStyle(color: context.colors.textSecondary),
                  ),
                  decoration: _fieldDecoration(context),
                  items: services
                      .map(
                        (s) => DropdownMenuItem<String>(
                          value: s['id']?.toString(),
                          child: Text(s['name']?.toString() ?? ''),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => selectedServiceId = val),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),

        _label(context, 'Date'),
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dateController,
              cursorColor: context.colors.mainColor,
              decoration: _fieldDecoration(
                context,
                prefixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: context.colors.textSecondary,
                ),
              ).copyWith(hintText: 'dd/mm/yyyy'),
            ),
          ),
        ),

        const SizedBox(height: 18),

        _label(context, 'Time'),
        GestureDetector(
          onTap: _pickTime,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _timeController,
              cursorColor: context.colors.mainColor,
              decoration: _fieldDecoration(
                context,
                prefixIcon: Icon(
                  Icons.access_time,
                  size: 18,
                  color: context.colors.textSecondary,
                ),
              ).copyWith(hintText: 'Select time'),
            ),
          ),
        ),

        const SizedBox(height: 18),

        _label(context, 'Notes (Optional)', required: false),
        TextFormField(
          controller: notesController,
          cursorColor: context.colors.mainColor, 
          maxLines: 4,
          decoration: _fieldDecoration(
            context,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Icon(Icons.note_outlined, size: 18),
            ),
          ).copyWith(hintText: 'Add any additional notes...'),
        ),
      ],
    );
  }
}