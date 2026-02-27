// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_init.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appInitDone)
const appInitDoneProvider = AppInitDoneProvider._();

final class AppInitDoneProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const AppInitDoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appInitDoneProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appInitDoneHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return appInitDone(ref);
  }
}

String _$appInitDoneHash() => r'7bfc51b050e56a1ffc80a03c62e33360e963f016';
