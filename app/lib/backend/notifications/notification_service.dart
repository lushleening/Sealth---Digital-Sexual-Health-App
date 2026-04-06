import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';

part 'notification_service.g.dart';

// Provider for the Plugin instance
final notificationPluginProvider = Provider(
  (ref) => FlutterLocalNotificationsPlugin(),
);

// Provider
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  final service = NotificationService(
    plugin: ref.watch(notificationPluginProvider),
    ref: ref,
  );
  service.init();
  return service;
}

class NotificationService {
  final Ref ref;
  final FlutterLocalNotificationsPlugin plugin;

  NotificationService({required this.plugin, required this.ref});

  Future<void> init() async {
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission(); // For Android 13+

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings a = AndroidInitializationSettings(
      'mipmap/launcher_icon',
    );
    final DarwinInitializationSettings d = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings i = InitializationSettings(
      android: a,
      iOS: d,
      macOS: d,
    );
    await plugin.initialize(
      settings: i,
      onDidReceiveNotificationResponse: (s) {
        final p = s.payload;
        if (p != null) ref.read(navRouter).go(p);
      },
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required String navigateToPath,
    Importance importance = Importance.defaultImportance,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_importance_${importance.value}',
        'General Notifications',
        channelDescription: 'Used for app-wide alerts',
        importance: importance,
        priority: _mapPriority(importance),
        showWhen: true,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await plugin.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: navigateToPath,
    );
  }

  // Helper to sync Priority with Importance for Android
  Priority _mapPriority(Importance importance) {
    switch (importance) {
      case Importance.max:
        return Priority.high;
      case Importance.high:
        return Priority.high;
      case Importance.low:
        return Priority.low;
      case Importance.min:
        return Priority.min;
      default:
        return Priority.defaultPriority;
    }
  }
}
