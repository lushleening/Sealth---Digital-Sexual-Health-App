// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_metadata.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppMetadataNotifier)
const appMetadataProvider = AppMetadataNotifierProvider._();

final class AppMetadataNotifierProvider
    extends $AsyncNotifierProvider<AppMetadataNotifier, AppMetadata> {
  const AppMetadataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appMetadataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appMetadataNotifierHash();

  @$internal
  @override
  AppMetadataNotifier create() => AppMetadataNotifier();
}

String _$appMetadataNotifierHash() =>
    r'fd9c0f59cc846e5ccadc86610f6d46055c09f87c';

abstract class _$AppMetadataNotifier extends $AsyncNotifier<AppMetadata> {
  FutureOr<AppMetadata> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AppMetadata>, AppMetadata>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppMetadata>, AppMetadata>,
              AsyncValue<AppMetadata>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
