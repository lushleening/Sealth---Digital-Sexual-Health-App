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

String _$supabaseAuthHash() => r'44bcbd51972ac03ed9c074bd54b90e7b1318fe42';
