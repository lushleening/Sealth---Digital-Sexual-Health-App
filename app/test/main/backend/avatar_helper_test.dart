import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/avatar_helper.dart';

void main() {
  Future<void> pumpAvatar(
    WidgetTester tester,
    String? avatarUrl,
    String name, {
    double radius = 20,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[lightAppColors],
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildAvatar(context, avatarUrl, name, radius: radius),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('buildAvatar', () {
    testWidgets('returns CircleAvatar for anonymous user', (tester) async {
      await pumpAvatar(tester, null, 'Anonymous');
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('returns CircleAvatar with person icon for user without avatar',
        (tester) async {
      await pumpAvatar(tester, null, 'Regular User');
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('returns CircleAvatar for empty avatar url', (tester) async {
      await pumpAvatar(tester, '', 'Regular User');
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('uses custom radius', (tester) async {
      await pumpAvatar(tester, null, 'Anonymous', radius: 30);
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, 30);
    });

    testWidgets('anonymous avatar uses person_outline icon', (tester) async {
      await pumpAvatar(tester, null, 'Anonymous');
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('non-anonymous without avatar uses person icon', (tester) async {
      await pumpAvatar(tester, null, 'John Doe');
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}