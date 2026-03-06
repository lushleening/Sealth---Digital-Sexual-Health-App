// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dark_mode_enabled.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(darkModeEnabled)
const darkModeEnabledProvider = DarkModeEnabledProvider._();

final class DarkModeEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const DarkModeEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'darkModeEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$darkModeEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return darkModeEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$darkModeEnabledHash() => r'5545792b0cc9cd6e7fd7a99f52254202ec65b58a';
