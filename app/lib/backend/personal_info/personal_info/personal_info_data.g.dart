// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PersonalInfoNotifier)
const personalInfoProvider = PersonalInfoNotifierProvider._();

final class PersonalInfoNotifierProvider
    extends $AsyncNotifierProvider<PersonalInfoNotifier, PersonalInfoData> {
  const PersonalInfoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalInfoNotifierHash();

  @$internal
  @override
  PersonalInfoNotifier create() => PersonalInfoNotifier();
}

String _$personalInfoNotifierHash() =>
    r'cfc697acb0846494948cdbdc76b0471b3bcb38e3';

abstract class _$PersonalInfoNotifier extends $AsyncNotifier<PersonalInfoData> {
  FutureOr<PersonalInfoData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<PersonalInfoData>, PersonalInfoData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PersonalInfoData>, PersonalInfoData>,
              AsyncValue<PersonalInfoData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
