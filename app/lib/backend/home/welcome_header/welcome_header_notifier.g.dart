// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_header_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WelcomeHeaderNotifier)
const welcomeHeaderProvider = WelcomeHeaderNotifierProvider._();

final class WelcomeHeaderNotifierProvider
    extends $AsyncNotifierProvider<WelcomeHeaderNotifier, WelcomeHeaderData> {
  const WelcomeHeaderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomeHeaderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomeHeaderNotifierHash();

  @$internal
  @override
  WelcomeHeaderNotifier create() => WelcomeHeaderNotifier();
}

String _$welcomeHeaderNotifierHash() =>
    r'2cbfc6845a10379f39254b1e35ccd1657a334d8b';

abstract class _$WelcomeHeaderNotifier
    extends $AsyncNotifier<WelcomeHeaderData> {
  FutureOr<WelcomeHeaderData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<WelcomeHeaderData>, WelcomeHeaderData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WelcomeHeaderData>, WelcomeHeaderData>,
              AsyncValue<WelcomeHeaderData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
