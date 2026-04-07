// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotifications _$AppNotificationsFromJson(Map<String, dynamic> json) =>
    _AppNotifications(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      notificationType: json['notification_type'] as String,
      isAlertMessage: json['is_alert_message'] as bool,
      hasRead: json['has_read'] as bool,
      linkToPage: json['link_to_page'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AppNotificationsToJson(_AppNotifications instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'notification_type': instance.notificationType,
      'is_alert_message': instance.isAlertMessage,
      'has_read': instance.hasRead,
      'link_to_page': instance.linkToPage,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
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
    extends
        $StreamNotifierProvider<
          AppNotificationNotifier,
          List<AppNotifications>
        > {
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
}

String _$appNotificationNotifierHash() =>
    r'e29afe07e50372b4f2b369bfd5c8299680ae45a0';

abstract class _$AppNotificationNotifier
    extends $StreamNotifier<List<AppNotifications>> {
  Stream<List<AppNotifications>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<AppNotifications>>, List<AppNotifications>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AppNotifications>>,
                List<AppNotifications>
              >,
              AsyncValue<List<AppNotifications>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
