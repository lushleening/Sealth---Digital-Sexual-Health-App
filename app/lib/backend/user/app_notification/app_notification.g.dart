// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

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
    r'39fd5597dc7938125d0f011f8a096dd8849ccfe3';

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
