import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/colors/dark_mode_enabled/dark_mode_enabled.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/logging_init.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Starts the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loggingInit();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  final db = Database();
  final syncService = AppointmentSyncService(
  db: db,
  client: Supabase.instance.client,
  );
  syncService.syncClinics().catchError((_) {});
  syncService.syncServices().catchError((_) {});

  runApp(ProviderScope(observers: [RiverpodObserver()], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => buildApp(ref);
}

// Separated out to be used for testing
Widget buildApp(WidgetRef ref) {
  final router = ref.watch(navRouter);
  return MaterialApp.router(
    scaffoldMessengerKey: scaffoldMessengerKey,
    title: ref
        .watch(appMetadataProvider)
        .maybeWhen(data: (m) => m.appName, orElse: () => 'APP'),
    theme: ThemeData(
      brightness: Brightness.light,
      extensions: const [lightAppColors],
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      extensions: const [darkAppColors],
    ),
    themeMode: ref.watch(darkModeEnabledProvider)
        ? ThemeMode.dark
        : ThemeMode.light,
    routerConfig: router,
  );
}
