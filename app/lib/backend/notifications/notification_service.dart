import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

part 'notification_service.g.dart';

// ALL STUFF IN THIS SHOULD NOT BE CALLED DIRECTLY,
// USE appNotificationProvider.* FUNCTION instead

// Provider for the plugin
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
  tz.initializeTimeZones();
  service.init();
  notificationsLogger.info("Notification service initialized.");
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
        ?.requestNotificationsPermission();

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
      windows: WindowsInitializationSettings(
        appName: '',
        appUserModelId: '',
        guid: '',
      ),
    );
    await plugin.initialize(
      settings: i,
      onDidReceiveNotificationResponse: (s) {
        final p = s.payload;
        if (p != null) ref.read(navRouter).go(p);
      },
    );
  }

  // Does not schedule old notifications, but also has a grace period for database sync lags
  Future<void> filterAndShowNotification(AppNotifications n) async {
    // Non-alert messages will not be scheduled, but still displayed in notification page
    final receiveNotifications = (await ref.read(
      appSettingsProvider.future,
    )).receiveNotifications;
    if (!receiveNotifications && !n.isAlertMessage) return;

    notificationsLogger.info("Notification scheduled: $n");
    final now = TZDateTime.now(local);
    final importance = n.isAlertMessage
        ? Importance.max
        : Importance.defaultImportance;

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
      windows: const WindowsNotificationDetails(),
    );

    final scheduledDate = TZDateTime.from(n.scheduledAt.toUtc(), local);
    if (scheduledDate.isAfter(now)) {
      await plugin.zonedSchedule(
        id: n.id,
        title: n.title,
        body: n.description,
        payload: n.linkToPage,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } else {
      // In case latency causes argument error, account for near past notifications
      final failCatchPeriod = now.subtract(latencyGracePeriod);
      if (scheduledDate.isAfter(failCatchPeriod)) {
        await plugin.show(
          id: n.id,
          title: n.title,
          body: n.description,
          payload: n.linkToPage,
          notificationDetails: notificationDetails,
        );
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await plugin.cancel(id: id);
    notificationsLogger.info("Scheduled notification cancelled: $id");
  }

  Future<void> cancelAll() async {
    await plugin.cancelAll();
    notificationsLogger.info("All scheduled notifications cleared.");
  }

  // Helper to sync Priority with Importance for Android
  Priority _mapPriority(Importance i) {
    switch (i) {
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
