// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppStatusNotifier)
const appStatusProvider = AppStatusNotifierProvider._();

final class AppStatusNotifierProvider
    extends $NotifierProvider<AppStatusNotifier, AppStatus> {
  const AppStatusNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStatusNotifierHash();

  @$internal
  @override
  AppStatusNotifier create() => AppStatusNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppStatus>(value),
    );
  }
}

String _$appStatusNotifierHash() => r'bad02e8d89aa1568b7c0685ffefc996ad395d976';

abstract class _$AppStatusNotifier extends $Notifier<AppStatus> {
  AppStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppStatus, AppStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppStatus, AppStatus>,
              AppStatus,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
