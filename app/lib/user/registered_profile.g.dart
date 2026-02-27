// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registered_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisteredProfile _$RegisteredProfileFromJson(Map<String, dynamic> json) =>
    _RegisteredProfile(
      supabaseId: json['supabase_id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      verified: json['verified'] as bool,
    );

Map<String, dynamic> _$RegisteredProfileToJson(_RegisteredProfile instance) =>
    <String, dynamic>{
      'supabase_id': instance.supabaseId,
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
      'verified': instance.verified,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisteredProfileNotifier)
const registeredProfileProvider = RegisteredProfileNotifierFamily._();

final class RegisteredProfileNotifierProvider
    extends
        $AsyncNotifierProvider<RegisteredProfileNotifier, RegisteredProfile?> {
  const RegisteredProfileNotifierProvider._({
    required RegisteredProfileNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'registeredProfileProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$registeredProfileNotifierHash();

  @override
  String toString() {
    return r'registeredProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RegisteredProfileNotifier create() => RegisteredProfileNotifier();

  @override
  bool operator ==(Object other) {
    return other is RegisteredProfileNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$registeredProfileNotifierHash() =>
    r'd47db80a0794b7a6e96e5d41a0b5e6642773de41';

final class RegisteredProfileNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RegisteredProfileNotifier,
          AsyncValue<RegisteredProfile?>,
          RegisteredProfile?,
          FutureOr<RegisteredProfile?>,
          String
        > {
  const RegisteredProfileNotifierFamily._()
    : super(
        retry: null,
        name: r'registeredProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RegisteredProfileNotifierProvider call(String supabaseId) =>
      RegisteredProfileNotifierProvider._(argument: supabaseId, from: this);

  @override
  String toString() => r'registeredProfileProvider';
}

abstract class _$RegisteredProfileNotifier
    extends $AsyncNotifier<RegisteredProfile?> {
  late final _$args = ref.$arg as String;
  String get supabaseId => _$args;

  FutureOr<RegisteredProfile?> build(String supabaseId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<RegisteredProfile?>, RegisteredProfile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RegisteredProfile?>, RegisteredProfile?>,
              AsyncValue<RegisteredProfile?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
