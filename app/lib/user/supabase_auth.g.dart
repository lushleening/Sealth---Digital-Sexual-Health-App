// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseAuth)
const supabaseAuthProvider = SupabaseAuthProvider._();

final class SupabaseAuthProvider
    extends $FunctionalProvider<SupabaseAuth, SupabaseAuth, SupabaseAuth>
    with $Provider<SupabaseAuth> {
  const SupabaseAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseAuthHash();

  @$internal
  @override
  $ProviderElement<SupabaseAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseAuth create(Ref ref) {
    return supabaseAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseAuth>(value),
    );
  }
}

String _$supabaseAuthHash() => r'5c57596466898995433a3ce24224d8f5404bd087';

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider extends $FunctionalProvider<User?, User?, User?>
    with $Provider<User?> {
  const CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$currentUserHash() => r'89259991cde37dafaa9541b027fd8d98ae662135';
