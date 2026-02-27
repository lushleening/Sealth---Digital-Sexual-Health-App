import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/pages/appointments/appointments.dart';
import 'package:sddp_dsh/pages/appointments/widgets/appointment_card.dart';
import 'package:sddp_dsh/objects/appointment.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  testWidgets('AppointmentsPage renders correctly', (
    WidgetTester tester,
  ) async {
    await initWidget(tester: tester, home: const AppointmentsPage());

    // Components exist
    expectObj(KBtn.reminderBanner);
    expectObj(KBtn.filterDropdown);
    expectObj(KBtn.addEvent);
    expectObj(KBtn.nearbyServices);
  });

  testWidgets('Tapping Add Event button navigates to AddEventPage', (
    WidgetTester tester,
  ) async {
    await initWidget(tester: tester, home: const AppointmentsPage());
    await tap(tester, find.byKey(KBtn.addEvent.key));

    // Verify navigation to AddEventPage by checking the AppBar title
    expect(find.text('Add New Event'), findsOneWidget);
  });

  testWidgets('Filter dropdown changes appointment list', (
    WidgetTester tester,
  ) async {
    await initWidget(tester: tester, home: const AppointmentsPage());

    await tap(tester, find.byType(DropdownButton<String>));
    await tap(tester, find.text('Today').first); // Select "Today"

    // Expect empty state message if no appointments today
    expect(find.text('No appointments scheduled for today.'), findsOneWidget);
  });

  testWidgets('Edit button navigates to EditEvents page', (tester) async {
    final appointment = Appointment(
      name: 'Downtown Health Center',
      description: 'STI Testing',
      datetime: DateTime(2026, 11, 9, 10, 0),
      linkToSubpage: const SafeContainer(child: Text("STI Testing")),
    );

    await initWidget(
      tester: tester,
      home: AppointmentCard(appointment: appointment),
    );

    await tap(tester, find.byIcon(Icons.edit_outlined));

    // Verify navigation by checking text from EditEvents
    expect(find.text('STI Testing'), findsOneWidget);
  });

  testWidgets('Nearby Services button is tappable', (
    WidgetTester tester,
  ) async {
    await initWidget(tester: tester, home: const AppointmentsPage());

    await tap(tester, find.byKey(KBtn.nearbyServices.key));
    expect(find.text('Nearby Services'), findsOneWidget);
  });
}
