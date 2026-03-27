// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_db_fetcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseDBFetcher)
const supabaseDBFetcherProvider = SupabaseDBFetcherProvider._();

final class SupabaseDBFetcherProvider
    extends
        $FunctionalProvider<
          SupabaseDBFetcher,
          SupabaseDBFetcher,
          SupabaseDBFetcher
        >
    with $Provider<SupabaseDBFetcher> {
  const SupabaseDBFetcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseDBFetcherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseDBFetcherHash();

  @$internal
  @override
  $ProviderElement<SupabaseDBFetcher> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupabaseDBFetcher create(Ref ref) {
    return supabaseDBFetcher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseDBFetcher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseDBFetcher>(value),
    );
  }
}

String _$supabaseDBFetcherHash() => r'95a5adf3f0e6947c21e718a5559a4eec3f377d75';
