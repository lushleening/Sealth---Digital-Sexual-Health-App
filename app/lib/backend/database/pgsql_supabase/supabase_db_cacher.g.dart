// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_db_cacher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseDBCacher)
const supabaseDBCacherProvider = SupabaseDBCacherProvider._();

final class SupabaseDBCacherProvider
    extends
        $FunctionalProvider<
          SupabaseDBCacher,
          SupabaseDBCacher,
          SupabaseDBCacher
        >
    with $Provider<SupabaseDBCacher> {
  const SupabaseDBCacherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseDBCacherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseDBCacherHash();

  @$internal
  @override
  $ProviderElement<SupabaseDBCacher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseDBCacher create(Ref ref) {
    return supabaseDBCacher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseDBCacher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseDBCacher>(value),
    );
  }
}

String _$supabaseDBCacherHash() => r'c5f84d97388feb5fff6461d8cd503ef11b8932b4';
