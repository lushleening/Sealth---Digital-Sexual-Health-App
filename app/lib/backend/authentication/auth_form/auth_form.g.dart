// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthFormNotifier)
const authFormProvider = AuthFormNotifierFamily._();

final class AuthFormNotifierProvider
    extends $NotifierProvider<AuthFormNotifier, AuthFormState> {
  const AuthFormNotifierProvider._({
    required AuthFormNotifierFamily super.from,
    required AuthFormType super.argument,
  }) : super(
         retry: null,
         name: r'authFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authFormNotifierHash();

  @override
  String toString() {
    return r'authFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AuthFormNotifier create() => AuthFormNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AuthFormNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authFormNotifierHash() => r'bbcbaf1c7fde4e5778744b8eb57253b8500e68ec';

final class AuthFormNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AuthFormNotifier,
          AuthFormState,
          AuthFormState,
          AuthFormState,
          AuthFormType
        > {
  const AuthFormNotifierFamily._()
    : super(
        retry: null,
        name: r'authFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AuthFormNotifierProvider call(AuthFormType formType) =>
      AuthFormNotifierProvider._(argument: formType, from: this);

  @override
  String toString() => r'authFormProvider';
}

abstract class _$AuthFormNotifier extends $Notifier<AuthFormState> {
  late final _$args = ref.$arg as AuthFormType;
  AuthFormType get formType => _$args;

  AuthFormState build(AuthFormType formType);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AuthFormState, AuthFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthFormState, AuthFormState>,
              AuthFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
