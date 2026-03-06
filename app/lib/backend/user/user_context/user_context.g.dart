// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_context.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserContextNotifier)
const userContextProvider = UserContextNotifierProvider._();

final class UserContextNotifierProvider
    extends $AsyncNotifierProvider<UserContextNotifier, UserContext> {
  const UserContextNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userContextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userContextNotifierHash();

  @$internal
  @override
  UserContextNotifier create() => UserContextNotifier();
}

String _$userContextNotifierHash() =>
    r'81bb5ce84e4b2a9af7cdd4c9cc83b2ddd6828ac3';

abstract class _$UserContextNotifier extends $AsyncNotifier<UserContext> {
  FutureOr<UserContext> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserContext>, UserContext>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserContext>, UserContext>,
              AsyncValue<UserContext>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
