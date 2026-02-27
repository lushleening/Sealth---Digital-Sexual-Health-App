// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(database)
const databaseProvider = DatabaseProvider._();

final class DatabaseProvider
    extends $FunctionalProvider<Database, Database, Database>
    with $Provider<Database> {
  const DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<Database> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Database create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Database value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Database>(value),
    );
  }
}

String _$databaseHash() => r'37c2851d988932b235ea51bd4f0864c387f96d67';

@ProviderFor(profilesDAO)
const profilesDAOProvider = ProfilesDAOProvider._();

final class ProfilesDAOProvider
    extends $FunctionalProvider<ProfilesDAO, ProfilesDAO, ProfilesDAO>
    with $Provider<ProfilesDAO> {
  const ProfilesDAOProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profilesDAOProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profilesDAOHash();

  @$internal
  @override
  $ProviderElement<ProfilesDAO> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProfilesDAO create(Ref ref) {
    return profilesDAO(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfilesDAO value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfilesDAO>(value),
    );
  }
}

String _$profilesDAOHash() => r'da9aa9af961e92fff2aaf67ab46ecd24a4dd2de8';

@ProviderFor(settingsDAO)
const settingsDAOProvider = SettingsDAOProvider._();

final class SettingsDAOProvider
    extends $FunctionalProvider<SettingsDAO, SettingsDAO, SettingsDAO>
    with $Provider<SettingsDAO> {
  const SettingsDAOProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsDAOProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsDAOHash();

  @$internal
  @override
  $ProviderElement<SettingsDAO> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsDAO create(Ref ref) {
    return settingsDAO(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsDAO value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsDAO>(value),
    );
  }
}

String _$settingsDAOHash() => r'aed0deee8cf137d9d27c0602393ffaeb3c3a1081';

@ProviderFor(usersDAO)
const usersDAOProvider = UsersDAOProvider._();

final class UsersDAOProvider
    extends $FunctionalProvider<UsersDAO, UsersDAO, UsersDAO>
    with $Provider<UsersDAO> {
  const UsersDAOProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersDAOProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersDAOHash();

  @$internal
  @override
  $ProviderElement<UsersDAO> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UsersDAO create(Ref ref) {
    return usersDAO(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsersDAO value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsersDAO>(value),
    );
  }
}

String _$usersDAOHash() => r'8b9e4a569686b6f58f579b716656bdb3a3999e6e';
