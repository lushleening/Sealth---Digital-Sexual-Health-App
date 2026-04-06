import 'package:drift/drift.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/dark_mode_enabled/dark_mode_enabled.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/constants/text_hints.dart';
import 'package:sddp_dsh/backend/logging/logging_init.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Starts the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Logging
  loggingInit();

  // Drift: Use ISO-Strings when storing datetime for compatibility with supabase timestamptz
  driftRuntimeOptions.defaultSerializer = ValueSerializer.defaults(
    serializeDateTimeValuesAsString: true,
  );

  try {
    // Supabase
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

    // FCM for sending remote notifications
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    // Initialize discussion managers
    final tempContainer = ProviderContainer();
    final discussionService = tempContainer.read(discussionServicesProvider);
    PostLikeManager().initialize(discussionService);
    PostCommentManager().initialize(discussionService);
    tempContainer.dispose();
  } catch (e, st) {
    uiLogger.severe(unexpectedInformDev, e, st);
  }

  // Run app
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
