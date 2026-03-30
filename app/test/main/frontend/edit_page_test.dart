import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';


void main() {
  final appointment = Appointment(
    name: 'Downtown Health Center',
    description: 'STI Testing',
    datetime: DateTime(2026, 11, 9, 10, 0),
    linkToSubpage: const SafeContainer(child: Text("STI Testing")),
  );

  // testWidgets('EditEvents page renders correctly', (WidgetTester tester) async {
  //   await initWidget(
  //     tester: tester,
  //     path: EditEvents(appointment: appointment),  // TODO try to use state.pathParameters to create the object
  //   );

  //   // Verify page loads
  //   expect(find.text('Edit Event'), findsOneWidget);

  //   // Verify buttons exist
  //   expectObj(KBtn.savebutton);
  //   expectObj(KBtn.deletebutton);
  //   expectObj(KBtn.cancelbutton);
  // });

  // testWidgets('Save button is tappable', (WidgetTester tester) async {
  //   await initWidget(
  //     tester: tester,
  //     path: EditEvents(appointment: appointment),  // TODO try to use state.pathParameters to create the object
  //   );
  //   await tap(tester, find.byKey(KBtn.savebutton.key));
  //   expectObj(KBtn.savebutton);
  // });

  // testWidgets('Delete button is tappable', (WidgetTester tester) async {
  //   await initWidget(
  //     tester: tester,
  //     path: EditEvents(appointment: appointment),  // TODO try to use state.pathParameters to create the object
  //   );
  //   await tap(tester, find.byKey(KBtn.deletebutton.key));
  //   expectObj(KBtn.deletebutton);
  // });

  // testWidgets('Cancel button is tappable', (WidgetTester tester) async {
  //   await initWidget(
  //     tester: tester,
  //     path: EditEvents(appointment: appointment),  // TODO try to use state.pathParameters to create the object
  //   );
  //   await tap(tester, find.byKey(KBtn.cancelbutton.key));
  //   expectObj(KBtn.cancelbutton);
  // });
}
