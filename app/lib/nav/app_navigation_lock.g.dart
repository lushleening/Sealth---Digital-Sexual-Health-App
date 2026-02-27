// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_navigation_lock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppNavigationLockNotifier)
const appNavigationLockProvider = AppNavigationLockNotifierProvider._();

final class AppNavigationLockNotifierProvider
    extends $NotifierProvider<AppNavigationLockNotifier, bool> {
  const AppNavigationLockNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appNavigationLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appNavigationLockNotifierHash();

  @$internal
  @override
  AppNavigationLockNotifier create() => AppNavigationLockNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$appNavigationLockNotifierHash() =>
    r'685e7596019fa8e9b624756b0dafca5fe17ddfc8';

abstract class _$AppNavigationLockNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
