// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_details_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditDetailsNotifier)
const editDetailsProvider = EditDetailsNotifierProvider._();

final class EditDetailsNotifierProvider
    extends $NotifierProvider<EditDetailsNotifier, EditDetailsFormState> {
  const EditDetailsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editDetailsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editDetailsNotifierHash();

  @$internal
  @override
  EditDetailsNotifier create() => EditDetailsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditDetailsFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditDetailsFormState>(value),
    );
  }
}

String _$editDetailsNotifierHash() =>
    r'c171ef1501b12db19b538b143fe03a2e31bef5b5';

abstract class _$EditDetailsNotifier extends $Notifier<EditDetailsFormState> {
  EditDetailsFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<EditDetailsFormState, EditDetailsFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EditDetailsFormState, EditDetailsFormState>,
              EditDetailsFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
