// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeDataNotifier)
const homeDataProvider = HomeDataNotifierProvider._();

final class HomeDataNotifierProvider
    extends $AsyncNotifierProvider<HomeDataNotifier, HomeData> {
  const HomeDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDataNotifierHash();

  @$internal
  @override
  HomeDataNotifier create() => HomeDataNotifier();
}

String _$homeDataNotifierHash() => r'49b8d7b861c8c73b4eecbabed9c71926e44e61f5';

abstract class _$HomeDataNotifier extends $AsyncNotifier<HomeData> {
  FutureOr<HomeData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<HomeData>, HomeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeData>, HomeData>,
              AsyncValue<HomeData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
