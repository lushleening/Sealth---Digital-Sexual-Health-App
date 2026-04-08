import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';

class EditEventsPage extends ConsumerStatefulWidget {
  final Appointment appointment;
  final void Function({
    required String clinicId,
    required String serviceId,
    required DateTime dateTime,
    String? notes,
  })
  onChanged;

  const EditEventsPage({
    required this.appointment,
    required this.onChanged,
    super.key,
  });

  @override
  ConsumerState<EditEventsPage> createState() => _EditEventsPageState();
}

class _EditEventsPageState extends ConsumerState<EditEventsPage> {
  String? selectedClinicId;
  String? selectedServiceId;
  DateTime? selectedDateTime;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    selectedClinicId = widget.appointment.clinicId;
    selectedServiceId = widget.appointment.serviceId;
    selectedDateTime = widget.appointment.datetime;

    final dt = widget.appointment.datetime;
    _dateController = TextEditingController(
      text:
          '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}',
    );
    _timeController = TextEditingController();
    notesController = TextEditingController(
      text: widget.appointment.notes ?? '',
    );

    // Notify parent with initial seeded values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notify();
    });
  }

  bool _timeInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_timeInitialized && selectedDateTime != null) {
      _timeController.text = TimeOfDay.fromDateTime(
        selectedDateTime!,
      ).format(context);
      _timeInitialized = true;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // Single method to notify parent with latest values
  void _notify() {
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
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: context.colors.mainColor
          ),
        ),
        child: child!,
      ),
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
      _notify();
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedDateTime != null
          ? TimeOfDay.fromDateTime(selectedDateTime!)
          : TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: context.colors.mainColor
          ),
        ),
        child: child!,
      ),
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
      _notify();
    }
  }

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
                    style: TextStyle(color: c.alert),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final clinicsAsync = ref.watch(clinicsProvider);
    final servicesAsync = selectedClinicId != null
        ? ref.watch(servicesProvider(selectedClinicId!))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Clinic ---
        _label(context, 'Location'),
        clinicsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error loading clinics: $e'),
          data: (clinics) => DropdownButtonFormField<String>(
            initialValue: selectedClinicId,
            dropdownColor: c.whiteBackground,
            hint: Text(
              'Select location',
              style: TextStyle(color: c.textSecondary, fontSize: 14),
            ),
            decoration: _fieldDecoration(context),
            items: clinics
                .map(
                  (clinic) => DropdownMenuItem<String>(
                    value: clinic['id']?.toString(),
                    child: Text(clinic['name']?.toString() ?? ''),
                  ),
                )
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedClinicId = val;
                selectedServiceId = null;
              });
              _notify();
            },
          ),
        ),

        const SizedBox(height: 18),

        // --- Service ---
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
                  dropdownColor: c.whiteBackground,
                  hint: Text(
                    'Select appointment type',
                    style: TextStyle(color: c.textSecondary, fontSize: 14),
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
                  onChanged: (val) {
                    setState(() => selectedServiceId = val);
                    _notify();
                  },
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),

        // --- Date ---
        _label(context, 'Date'),
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dateController,
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
            ),
          ),
        ),

        const SizedBox(height: 18),

        // --- Time ---
        _label(context, 'Time'),
        GestureDetector(
          onTap: _pickTime,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _timeController,
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
            ),
          ),
        ),

        const SizedBox(height: 18),

        // --- Notes ---
        _label(context, 'Notes (Optional)', required: false),
        TextFormField(
          controller: notesController,
          maxLines: 4,
          // Notify parent on every keystroke
          onChanged: (_) => _notify(),
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
