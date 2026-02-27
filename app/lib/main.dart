import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:sddp_dsh/common_widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/app_metadata.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/helper/snackbar_message.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/login.dart';
import 'package:sddp_dsh/pages/loading/loading.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/settings/providers/app_settings.dart';
import 'package:sddp_dsh/nav/app_status.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _loggingInit();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(ProviderScope(observers: [RiverpodObserver()], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => buildApp(ref);
}

// Just like python's if __name__ == "__main__"
// Separated out to be used for testing
Widget buildApp(WidgetRef ref, {Widget? home}) {
  return MaterialApp(
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
    themeMode: ref
        .watch(appSettingsProvider)
        .when(
          data: (data) => data.darkMode ? ThemeMode.dark : ThemeMode.light,
          error: (_, _) {
            uiLogger.shout("Color scheme not set, defaulting to light mode.");
            return ThemeMode.light;
          },
          loading: () => ThemeMode.light,
        ),
    home: home ?? _getHome(ref.watch(appStatusProvider)),
  );
}

// Switches page based on AppStatus
Widget _getHome(AppStatus status) {
  switch (status) {
    case AppStatus.loading:
      return const LoadingPage();
    case AppStatus.unauthenticated:
      return LoginPage(key: KPage.login.key);
    case AppStatus.authenticated:
      return const MainScaffold();
  }
}

// TODO: AnimatedSwitcher for page transitions
// Prompt login on every app entry (Maybe a bottom popup)
// brick_offline_first_with_supabase (Maybe need this)

void _loggingInit() {
  Logger.root.level = kDebugMode ? Level.FINE : Level.SHOUT;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name} -- ${record.time} -- ${record.loggerName} -- ${record.message}',
    );
  });
}
