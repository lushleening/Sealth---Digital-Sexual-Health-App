// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_page_route.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MainPageRouteNotifier)
@Deprecated(
  'This will be removed in favor of go_router, check nav_router.dart for more info',
)
const mainPageRouteProvider = MainPageRouteNotifierProvider._();

@Deprecated(
  'This will be removed in favor of go_router, check nav_router.dart for more info',
)
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
    r'c496d440716e580b07ff64ad5719ead2881e3e35';

@Deprecated(
  'This will be removed in favor of go_router, check nav_router.dart for more info',
)
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
