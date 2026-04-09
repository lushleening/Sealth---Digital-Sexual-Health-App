// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseService)
const supabaseServiceProvider = SupabaseServiceProvider._();

final class SupabaseServiceProvider
    extends $FunctionalProvider<SupabaseClient, SupabaseClient, SupabaseClient>
    with $Provider<SupabaseClient> {
  const SupabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseServiceHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient create(Ref ref) {
    return supabaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient>(value),
    );
  }
}

String _$supabaseServiceHash() => r'98aff54e90a0aa1f24b701a0a6d0844704c2a015';

@ProviderFor(supabaseHealthCheck)
const supabaseHealthCheckProvider = SupabaseHealthCheckProvider._();

final class SupabaseHealthCheckProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const SupabaseHealthCheckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseHealthCheckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseHealthCheckHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return supabaseHealthCheck(ref);
  }
}

String _$supabaseHealthCheckHash() =>
    r'1c60a6612eceeba1bad882624b82d1ce8c14fd44';
