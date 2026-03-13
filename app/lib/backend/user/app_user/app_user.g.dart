// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppUserNotifier)
const appUserProvider = AppUserNotifierProvider._();

final class AppUserNotifierProvider
    extends $AsyncNotifierProvider<AppUserNotifier, AppUser> {
  const AppUserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUserNotifierHash();

  @$internal
  @override
  AppUserNotifier create() => AppUserNotifier();
}

String _$appUserNotifierHash() => r'2c25273df7c3b3ebe6a33cbb330824a8f0bc4c4b';

abstract class _$AppUserNotifier extends $AsyncNotifier<AppUser> {
  FutureOr<AppUser> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AppUser>, AppUser>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppUser>, AppUser>,
              AsyncValue<AppUser>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
