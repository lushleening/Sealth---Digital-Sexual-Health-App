// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotifications _$AppNotificationsFromJson(Map<String, dynamic> json) =>
    _AppNotifications(
      uuid: json['uuid'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      notificationType: json['notification_type'] as String,
      isAlertMessage: json['is_alert_message'] as bool,
      hasRead: json['has_read'] as bool,
      linkToPage: json['link_to_page'] as String,
      pushDateTime: DateTime.parse(json['push_datetime'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AppNotificationsToJson(_AppNotifications instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'description': instance.description,
      'notification_type': instance.notificationType,
      'is_alert_message': instance.isAlertMessage,
      'has_read': instance.hasRead,
      'link_to_page': instance.linkToPage,
      'push_datetime': instance.pushDateTime.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppNotificationNotifier)
const appNotificationProvider = AppNotificationNotifierProvider._();

final class AppNotificationNotifierProvider
    extends $NotifierProvider<AppNotificationNotifier, List<AppNotifications>> {
  const AppNotificationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appNotificationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appNotificationNotifierHash();

  @$internal
  @override
  AppNotificationNotifier create() => AppNotificationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AppNotifications> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AppNotifications>>(value),
    );
  }
}

String _$appNotificationNotifierHash() =>
    r'095ab5fe54b506f8295c4807c4ed684b80dfb82b';

abstract class _$AppNotificationNotifier
    extends $Notifier<List<AppNotifications>> {
  List<AppNotifications> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<AppNotifications>, List<AppNotifications>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<AppNotifications>, List<AppNotifications>>,
              List<AppNotifications>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
