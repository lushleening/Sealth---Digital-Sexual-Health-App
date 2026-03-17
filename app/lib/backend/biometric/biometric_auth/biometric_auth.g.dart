// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(biometricAuth)
const biometricAuthProvider = BiometricAuthProvider._();

final class BiometricAuthProvider
    extends $FunctionalProvider<BiometricAuth, BiometricAuth, BiometricAuth>
    with $Provider<BiometricAuth> {
  const BiometricAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricAuthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricAuthHash();

  @$internal
  @override
  $ProviderElement<BiometricAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BiometricAuth create(Ref ref) {
    return biometricAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometricAuth>(value),
    );
  }
}

String _$biometricAuthHash() => r'257ee3e870cc8ab3bfc95c3358005307c2cc82b0';
