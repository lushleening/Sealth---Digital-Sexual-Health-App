// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_rt_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseRTService)
const supabaseRTServiceProvider = SupabaseRTServiceProvider._();

final class SupabaseRTServiceProvider
    extends
        $FunctionalProvider<
          SupabaseRealtimeService,
          SupabaseRealtimeService,
          SupabaseRealtimeService
        >
    with $Provider<SupabaseRealtimeService> {
  const SupabaseRTServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseRTServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseRTServiceHash();

  @$internal
  @override
  $ProviderElement<SupabaseRealtimeService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupabaseRealtimeService create(Ref ref) {
    return supabaseRTService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseRealtimeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseRealtimeService>(value),
    );
  }
}

String _$supabaseRTServiceHash() => r'0e36874b744e1a71347b0c75c301e1a2026c5b35';
