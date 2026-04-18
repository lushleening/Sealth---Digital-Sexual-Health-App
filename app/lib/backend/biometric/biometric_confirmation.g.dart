// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_confirmation.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(biometricConfirmation)
const biometricConfirmationProvider = BiometricConfirmationProvider._();

final class BiometricConfirmationProvider
    extends
        $FunctionalProvider<
          BiometricConfirmation,
          BiometricConfirmation,
          BiometricConfirmation
        >
    with $Provider<BiometricConfirmation> {
  const BiometricConfirmationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricConfirmationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricConfirmationHash();

  @$internal
  @override
  $ProviderElement<BiometricConfirmation> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BiometricConfirmation create(Ref ref) {
    return biometricConfirmation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricConfirmation value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometricConfirmation>(value),
    );
  }
}

String _$biometricConfirmationHash() =>
    r'37132336c31519d161aa740ac1b4aaa09d776e29';

@ProviderFor(localAuthentication)
const localAuthenticationProvider = LocalAuthenticationProvider._();

final class LocalAuthenticationProvider
    extends
        $FunctionalProvider<
          LocalAuthentication,
          LocalAuthentication,
          LocalAuthentication
        >
    with $Provider<LocalAuthentication> {
  const LocalAuthenticationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAuthenticationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAuthenticationHash();

  @$internal
  @override
  $ProviderElement<LocalAuthentication> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalAuthentication create(Ref ref) {
    return localAuthentication(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalAuthentication value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalAuthentication>(value),
    );
  }
}

String _$localAuthenticationHash() =>
    r'40d0bc52d5244081d245b8918ab018a228249849';
