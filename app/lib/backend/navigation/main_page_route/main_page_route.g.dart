// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_page_route.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MainPageRouteNotifier)
const mainPageRouteProvider = MainPageRouteNotifierProvider._();

final class MainPageRouteNotifierProvider
    extends $NotifierProvider<MainPageRouteNotifier, MainPageRoute> {
  const MainPageRouteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainPageRouteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainPageRouteNotifierHash();

  @$internal
  @override
  MainPageRouteNotifier create() => MainPageRouteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MainPageRoute value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MainPageRoute>(value),
    );
  }
}

String _$mainPageRouteNotifierHash() =>
    r'cb08abdcecaf85d0795b7cde21e89e758d4c8607';

abstract class _$MainPageRouteNotifier extends $Notifier<MainPageRoute> {
  MainPageRoute build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MainPageRoute, MainPageRoute>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MainPageRoute, MainPageRoute>,
              MainPageRoute,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
