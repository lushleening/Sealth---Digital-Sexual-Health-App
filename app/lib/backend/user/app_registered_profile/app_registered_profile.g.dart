// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_registered_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppRegisteredProfile _$AppRegisteredProfileFromJson(
  Map<String, dynamic> json,
) => _AppRegisteredProfile(
  username: json['username'] as String,
  avatarUrl: json['avatar_url'] as String?,
  verified: json['verified'] as bool,
);

Map<String, dynamic> _$AppRegisteredProfileToJson(
  _AppRegisteredProfile instance,
) => <String, dynamic>{
  'username': instance.username,
  'avatar_url': instance.avatarUrl,
  'verified': instance.verified,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppRegisteredProfileNotifier)
const appRegisteredProfileProvider = AppRegisteredProfileNotifierProvider._();

final class AppRegisteredProfileNotifierProvider
    extends
        $StreamNotifierProvider<
          AppRegisteredProfileNotifier,
          AppRegisteredProfile?
        > {
  const AppRegisteredProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRegisteredProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRegisteredProfileNotifierHash();

  @$internal
  @override
  AppRegisteredProfileNotifier create() => AppRegisteredProfileNotifier();
}

String _$appRegisteredProfileNotifierHash() =>
    r'47c7ff4227940396d331f5234c64050dfaf50571';

abstract class _$AppRegisteredProfileNotifier
    extends $StreamNotifier<AppRegisteredProfile?> {
  Stream<AppRegisteredProfile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<AppRegisteredProfile?>, AppRegisteredProfile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AppRegisteredProfile?>,
                AppRegisteredProfile?
              >,
              AsyncValue<AppRegisteredProfile?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
