// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncService)
const syncServiceProvider = SyncServiceProvider._();

final class SyncServiceProvider
    extends $NotifierProvider<SyncService, SyncService> {
  const SyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  SyncService create() => SyncService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncService>(value),
    );
  }
}

String _$syncServiceHash() => r'645b18d8be157263c965e57ee5d3ddb5e29faf7f';

abstract class _$SyncService extends $Notifier<SyncService> {
  SyncService build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SyncService, SyncService>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncService, SyncService>,
              SyncService,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
