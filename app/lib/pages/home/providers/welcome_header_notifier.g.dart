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
    r'7babbaee24cf3f4edfc44aed56a5229771b4ea34';

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
