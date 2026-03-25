// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_details_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditDetailsFormNotifier)
const editDetailsFormProvider = EditDetailsFormNotifierProvider._();

final class EditDetailsFormNotifierProvider
    extends $NotifierProvider<EditDetailsFormNotifier, EditDetailsFormState> {
  const EditDetailsFormNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editDetailsFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editDetailsFormNotifierHash();

  @$internal
  @override
  EditDetailsFormNotifier create() => EditDetailsFormNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditDetailsFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditDetailsFormState>(value),
    );
  }
}

String _$editDetailsFormNotifierHash() =>
    r'a5058917db3bcc714bcd955898a75d4992dece0f';

abstract class _$EditDetailsFormNotifier
    extends $Notifier<EditDetailsFormState> {
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
