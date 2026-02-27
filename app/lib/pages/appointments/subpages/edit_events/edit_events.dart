import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/objects/appointment.dart';
import 'package:sddp_dsh/pages/appointments/subpages/edit_events/widgets/edit_event_card.dart';
import 'package:sddp_dsh/pages/appointments/subpages/edit_events/widgets/save_but.dart';
import 'package:sddp_dsh/pages/appointments/subpages/edit_events/widgets/del_but.dart';
import 'package:sddp_dsh/pages/appointments/subpages/edit_events/widgets/cancel_but.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

class EditEvents extends StatefulWidget {
  final Appointment appointment;

  const EditEvents({super.key, required this.appointment});

  @override
  State<EditEvents> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvents> {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.grayBackground,
      appBar: AppBar(
        title: const Text("Edit Event"),
        backgroundColor: c.mainColor,
        foregroundColor: c.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            EditEventsPage(appointment: widget.appointment),
            const SizedBox(height: 130),
            SaveButton(key: KBtn.savebutton.key, onPressed: () {}),
            const SizedBox(height: 16),
            Deletebtn(key: KBtn.deletebutton.key, onPressed: () {}),
            const SizedBox(height: 16),
            Cancelbtn(key: KBtn.cancelbutton.key, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
