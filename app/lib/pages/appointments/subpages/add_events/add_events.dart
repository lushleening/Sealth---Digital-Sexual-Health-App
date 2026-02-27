import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/objects/appointment.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/pages/appointments/subpages/add_events/widgets/add_btn.dart';
import 'package:sddp_dsh/pages/appointments/subpages/add_events/widgets/cancel_btn.dart';
import 'package:sddp_dsh/pages/appointments/subpages/add_events/widgets/events.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

final appointments = [
  Appointment(
    name: 'Downtown Health Center',
    description: 'STI Testing',
    datetime: DateTime(2026, 11, 9, 10, 0),
    linkToSubpage: const SafeContainer(child: Text("STI Testing")),
  ),
  Appointment(
    name: 'Westside Health Center',
    description: 'Contraception Consultation',
    datetime: DateTime(2026, 11, 20, 12, 0),
    linkToSubpage: const SafeContainer(child: Text("Consultation")),
  ),
];

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: KPage.addEvents.key,
      backgroundColor: context.colors.grayBackground,
      appBar: AppBar(
        title: const Text("Add New Event"),
        backgroundColor: context.colors.mainColor,
        foregroundColor: context.colors.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 16),
            EventsPage(events: appointments),
            const SizedBox(height: 16),
            AddButton(key: KBtn.eventaddbutton.key, onPressed: () {}),
            const SizedBox(height: 16),
            Cancelbtn(key: KBtn.cancelbutton.key, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
