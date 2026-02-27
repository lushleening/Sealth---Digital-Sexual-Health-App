// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supabaseIdMeta = const VerificationMeta(
    'supabaseId',
  );
  @override
  late final GeneratedColumn<String> supabaseId = GeneratedColumn<String>(
    'supabase_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isGuestMeta = const VerificationMeta(
    'isGuest',
  );
  @override
  late final GeneratedColumn<bool> isGuest = GeneratedColumn<bool>(
    'is_guest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_guest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastLoggedInMeta = const VerificationMeta(
    'lastLoggedIn',
  );
  @override
  late final GeneratedColumn<DateTime> lastLoggedIn = GeneratedColumn<DateTime>(
    'last_logged_in',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: Variable(DateTime.now()),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    supabaseId,
    isGuest,
    lastLoggedIn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('supabase_id')) {
      context.handle(
        _supabaseIdMeta,
        supabaseId.isAcceptableOrUnknown(data['supabase_id']!, _supabaseIdMeta),
      );
    }
    if (data.containsKey('is_guest')) {
      context.handle(
        _isGuestMeta,
        isGuest.isAcceptableOrUnknown(data['is_guest']!, _isGuestMeta),
      );
    }
    if (data.containsKey('last_logged_in')) {
      context.handle(
        _lastLoggedInMeta,
        lastLoggedIn.isAcceptableOrUnknown(
          data['last_logged_in']!,
          _lastLoggedInMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      supabaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supabase_id'],
      ),
      isGuest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_guest'],
      )!,
      lastLoggedIn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_logged_in'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String localId;
  final String? supabaseId;
  final bool isGuest;
  final DateTime lastLoggedIn;
  const User({
    required this.localId,
    this.supabaseId,
    required this.isGuest,
    required this.lastLoggedIn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || supabaseId != null) {
      map['supabase_id'] = Variable<String>(supabaseId);
    }
    map['is_guest'] = Variable<bool>(isGuest);
    map['last_logged_in'] = Variable<DateTime>(lastLoggedIn);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      localId: Value(localId),
      supabaseId: supabaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(supabaseId),
      isGuest: Value(isGuest),
      lastLoggedIn: Value(lastLoggedIn),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      localId: serializer.fromJson<String>(json['localId']),
      supabaseId: serializer.fromJson<String?>(json['supabaseId']),
      isGuest: serializer.fromJson<bool>(json['isGuest']),
      lastLoggedIn: serializer.fromJson<DateTime>(json['lastLoggedIn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'supabaseId': serializer.toJson<String?>(supabaseId),
      'isGuest': serializer.toJson<bool>(isGuest),
      'lastLoggedIn': serializer.toJson<DateTime>(lastLoggedIn),
    };
  }

  User copyWith({
    String? localId,
    Value<String?> supabaseId = const Value.absent(),
    bool? isGuest,
    DateTime? lastLoggedIn,
  }) => User(
    localId: localId ?? this.localId,
    supabaseId: supabaseId.present ? supabaseId.value : this.supabaseId,
    isGuest: isGuest ?? this.isGuest,
    lastLoggedIn: lastLoggedIn ?? this.lastLoggedIn,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      localId: data.localId.present ? data.localId.value : this.localId,
      supabaseId: data.supabaseId.present
          ? data.supabaseId.value
          : this.supabaseId,
      isGuest: data.isGuest.present ? data.isGuest.value : this.isGuest,
      lastLoggedIn: data.lastLoggedIn.present
          ? data.lastLoggedIn.value
          : this.lastLoggedIn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('localId: $localId, ')
          ..write('supabaseId: $supabaseId, ')
          ..write('isGuest: $isGuest, ')
          ..write('lastLoggedIn: $lastLoggedIn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localId, supabaseId, isGuest, lastLoggedIn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.localId == this.localId &&
          other.supabaseId == this.supabaseId &&
          other.isGuest == this.isGuest &&
          other.lastLoggedIn == this.lastLoggedIn);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> localId;
  final Value<String?> supabaseId;
  final Value<bool> isGuest;
  final Value<DateTime> lastLoggedIn;
  final Value<int> rowid;
  const UsersCompanion({
    this.localId = const Value.absent(),
    this.supabaseId = const Value.absent(),
    this.isGuest = const Value.absent(),
    this.lastLoggedIn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String localId,
    this.supabaseId = const Value.absent(),
    this.isGuest = const Value.absent(),
    this.lastLoggedIn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId);
  static Insertable<User> custom({
    Expression<String>? localId,
    Expression<String>? supabaseId,
    Expression<bool>? isGuest,
    Expression<DateTime>? lastLoggedIn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (supabaseId != null) 'supabase_id': supabaseId,
      if (isGuest != null) 'is_guest': isGuest,
      if (lastLoggedIn != null) 'last_logged_in': lastLoggedIn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? localId,
    Value<String?>? supabaseId,
    Value<bool>? isGuest,
    Value<DateTime>? lastLoggedIn,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      localId: localId ?? this.localId,
      supabaseId: supabaseId ?? this.supabaseId,
      isGuest: isGuest ?? this.isGuest,
      lastLoggedIn: lastLoggedIn ?? this.lastLoggedIn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (supabaseId.present) {
      map['supabase_id'] = Variable<String>(supabaseId.value);
    }
    if (isGuest.present) {
      map['is_guest'] = Variable<bool>(isGuest.value);
    }
    if (lastLoggedIn.present) {
      map['last_logged_in'] = Variable<DateTime>(lastLoggedIn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('localId: $localId, ')
          ..write('supabaseId: $supabaseId, ')
          ..write('isGuest: $isGuest, ')
          ..write('lastLoggedIn: $lastLoggedIn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _supabaseIdMeta = const VerificationMeta(
    'supabaseId',
  );
  @override
  late final GeneratedColumn<String> supabaseId = GeneratedColumn<String>(
    'supabase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (supabase_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verifiedMeta = const VerificationMeta(
    'verified',
  );
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
    'verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    supabaseId,
    username,
    email,
    avatarUrl,
    verified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('supabase_id')) {
      context.handle(
        _supabaseIdMeta,
        supabaseId.isAcceptableOrUnknown(data['supabase_id']!, _supabaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supabaseIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('verified')) {
      context.handle(
        _verifiedMeta,
        verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {supabaseId};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      supabaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supabase_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      verified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String supabaseId;
  final String username;
  final String? email;
  final String? avatarUrl;
  final bool verified;
  const Profile({
    required this.supabaseId,
    required this.username,
    this.email,
    this.avatarUrl,
    required this.verified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['supabase_id'] = Variable<String>(supabaseId);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['verified'] = Variable<bool>(verified);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      supabaseId: Value(supabaseId),
      username: Value(username),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      verified: Value(verified),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      supabaseId: serializer.fromJson<String>(json['supabaseId']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String?>(json['email']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      verified: serializer.fromJson<bool>(json['verified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'supabaseId': serializer.toJson<String>(supabaseId),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String?>(email),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'verified': serializer.toJson<bool>(verified),
    };
  }

  Profile copyWith({
    String? supabaseId,
    String? username,
    Value<String?> email = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    bool? verified,
  }) => Profile(
    supabaseId: supabaseId ?? this.supabaseId,
    username: username ?? this.username,
    email: email.present ? email.value : this.email,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    verified: verified ?? this.verified,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      supabaseId: data.supabaseId.present
          ? data.supabaseId.value
          : this.supabaseId,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      verified: data.verified.present ? data.verified.value : this.verified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('supabaseId: $supabaseId, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('verified: $verified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(supabaseId, username, email, avatarUrl, verified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.supabaseId == this.supabaseId &&
          other.username == this.username &&
          other.email == this.email &&
          other.avatarUrl == this.avatarUrl &&
          other.verified == this.verified);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> supabaseId;
  final Value<String> username;
  final Value<String?> email;
  final Value<String?> avatarUrl;
  final Value<bool> verified;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.supabaseId = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.verified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String supabaseId,
    required String username,
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.verified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : supabaseId = Value(supabaseId),
       username = Value(username);
  static Insertable<Profile> custom({
    Expression<String>? supabaseId,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? avatarUrl,
    Expression<bool>? verified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (supabaseId != null) 'supabase_id': supabaseId,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (verified != null) 'verified': verified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? supabaseId,
    Value<String>? username,
    Value<String?>? email,
    Value<String?>? avatarUrl,
    Value<bool>? verified,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      supabaseId: supabaseId ?? this.supabaseId,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      verified: verified ?? this.verified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (supabaseId.present) {
      map['supabase_id'] = Variable<String>(supabaseId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('supabaseId: $supabaseId, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('verified: $verified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (local_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _darkModeMeta = const VerificationMeta(
    'darkMode',
  );
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
    'dark_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dark_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _receiveNotificationsMeta =
      const VerificationMeta('receiveNotifications');
  @override
  late final GeneratedColumn<bool> receiveNotifications = GeneratedColumn<bool>(
    'receive_notifications',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("receive_notifications" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _autoSyncMeta = const VerificationMeta(
    'autoSync',
  );
  @override
  late final GeneratedColumn<bool> autoSync = GeneratedColumn<bool>(
    'auto_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoUpdateMeta = const VerificationMeta(
    'autoUpdate',
  );
  @override
  late final GeneratedColumn<bool> autoUpdate = GeneratedColumn<bool>(
    'auto_update',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_update" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    darkMode,
    receiveNotifications,
    autoSync,
    autoUpdate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('dark_mode')) {
      context.handle(
        _darkModeMeta,
        darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta),
      );
    }
    if (data.containsKey('receive_notifications')) {
      context.handle(
        _receiveNotificationsMeta,
        receiveNotifications.isAcceptableOrUnknown(
          data['receive_notifications']!,
          _receiveNotificationsMeta,
        ),
      );
    }
    if (data.containsKey('auto_sync')) {
      context.handle(
        _autoSyncMeta,
        autoSync.isAcceptableOrUnknown(data['auto_sync']!, _autoSyncMeta),
      );
    }
    if (data.containsKey('auto_update')) {
      context.handle(
        _autoUpdateMeta,
        autoUpdate.isAcceptableOrUnknown(data['auto_update']!, _autoUpdateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      darkMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dark_mode'],
      )!,
      receiveNotifications: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}receive_notifications'],
      )!,
      autoSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_sync'],
      )!,
      autoUpdate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_update'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String localId;
  final bool darkMode;
  final bool receiveNotifications;
  final bool autoSync;
  final bool autoUpdate;
  const Setting({
    required this.id,
    required this.localId,
    required this.darkMode,
    required this.receiveNotifications,
    required this.autoSync,
    required this.autoUpdate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    map['dark_mode'] = Variable<bool>(darkMode);
    map['receive_notifications'] = Variable<bool>(receiveNotifications);
    map['auto_sync'] = Variable<bool>(autoSync);
    map['auto_update'] = Variable<bool>(autoUpdate);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      localId: Value(localId),
      darkMode: Value(darkMode),
      receiveNotifications: Value(receiveNotifications),
      autoSync: Value(autoSync),
      autoUpdate: Value(autoUpdate),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['localId']),
      darkMode: serializer.fromJson<bool>(json['darkMode']),
      receiveNotifications: serializer.fromJson<bool>(
        json['receiveNotifications'],
      ),
      autoSync: serializer.fromJson<bool>(json['autoSync']),
      autoUpdate: serializer.fromJson<bool>(json['autoUpdate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localId': serializer.toJson<String>(localId),
      'darkMode': serializer.toJson<bool>(darkMode),
      'receiveNotifications': serializer.toJson<bool>(receiveNotifications),
      'autoSync': serializer.toJson<bool>(autoSync),
      'autoUpdate': serializer.toJson<bool>(autoUpdate),
    };
  }

  Setting copyWith({
    int? id,
    String? localId,
    bool? darkMode,
    bool? receiveNotifications,
    bool? autoSync,
    bool? autoUpdate,
  }) => Setting(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    darkMode: darkMode ?? this.darkMode,
    receiveNotifications: receiveNotifications ?? this.receiveNotifications,
    autoSync: autoSync ?? this.autoSync,
    autoUpdate: autoUpdate ?? this.autoUpdate,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
      receiveNotifications: data.receiveNotifications.present
          ? data.receiveNotifications.value
          : this.receiveNotifications,
      autoSync: data.autoSync.present ? data.autoSync.value : this.autoSync,
      autoUpdate: data.autoUpdate.present
          ? data.autoUpdate.value
          : this.autoUpdate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('darkMode: $darkMode, ')
          ..write('receiveNotifications: $receiveNotifications, ')
          ..write('autoSync: $autoSync, ')
          ..write('autoUpdate: $autoUpdate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    darkMode,
    receiveNotifications,
    autoSync,
    autoUpdate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.darkMode == this.darkMode &&
          other.receiveNotifications == this.receiveNotifications &&
          other.autoSync == this.autoSync &&
          other.autoUpdate == this.autoUpdate);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> localId;
  final Value<bool> darkMode;
  final Value<bool> receiveNotifications;
  final Value<bool> autoSync;
  final Value<bool> autoUpdate;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.receiveNotifications = const Value.absent(),
    this.autoSync = const Value.absent(),
    this.autoUpdate = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    this.darkMode = const Value.absent(),
    this.receiveNotifications = const Value.absent(),
    this.autoSync = const Value.absent(),
    this.autoUpdate = const Value.absent(),
  }) : localId = Value(localId);
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<bool>? darkMode,
    Expression<bool>? receiveNotifications,
    Expression<bool>? autoSync,
    Expression<bool>? autoUpdate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (darkMode != null) 'dark_mode': darkMode,
      if (receiveNotifications != null)
        'receive_notifications': receiveNotifications,
      if (autoSync != null) 'auto_sync': autoSync,
      if (autoUpdate != null) 'auto_update': autoUpdate,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<bool>? darkMode,
    Value<bool>? receiveNotifications,
    Value<bool>? autoSync,
    Value<bool>? autoUpdate,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      darkMode: darkMode ?? this.darkMode,
      receiveNotifications: receiveNotifications ?? this.receiveNotifications,
      autoSync: autoSync ?? this.autoSync,
      autoUpdate: autoUpdate ?? this.autoUpdate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    if (receiveNotifications.present) {
      map['receive_notifications'] = Variable<bool>(receiveNotifications.value);
    }
    if (autoSync.present) {
      map['auto_sync'] = Variable<bool>(autoSync.value);
    }
    if (autoUpdate.present) {
      map['auto_update'] = Variable<bool>(autoUpdate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('darkMode: $darkMode, ')
          ..write('receiveNotifications: $receiveNotifications, ')
          ..write('autoSync: $autoSync, ')
          ..write('autoUpdate: $autoUpdate')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    profiles,
    settings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('profiles', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('settings', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String localId,
      Value<String?> supabaseId,
      Value<bool> isGuest,
      Value<DateTime> lastLoggedIn,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> localId,
      Value<String?> supabaseId,
      Value<bool> isGuest,
      Value<DateTime> lastLoggedIn,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$Database, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProfilesTable, List<Profile>> _profilesRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.profiles,
    aliasName: $_aliasNameGenerator(
      db.users.supabaseId,
      db.profiles.supabaseId,
    ),
  );

  $$ProfilesTableProcessedTableManager get profilesRefs {
    final manager = $$ProfilesTableTableManager($_db, $_db.profiles).filter(
      (f) => f.supabaseId.supabaseId.sqlEquals(
        $_itemColumn<String>('supabase_id'),
      ),
    );

    final cache = $_typedResult.readTableOrNull(_profilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SettingsTable, List<Setting>> _settingsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.settings,
    aliasName: $_aliasNameGenerator(db.users.localId, db.settings.localId),
  );

  $$SettingsTableProcessedTableManager get settingsRefs {
    final manager = $$SettingsTableTableManager($_db, $_db.settings).filter(
      (f) => f.localId.localId.sqlEquals($_itemColumn<String>('local_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_settingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$Database, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supabaseId => $composableBuilder(
    column: $table.supabaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGuest => $composableBuilder(
    column: $table.isGuest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLoggedIn => $composableBuilder(
    column: $table.lastLoggedIn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> profilesRefs(
    Expression<bool> Function($$ProfilesTableFilterComposer f) f,
  ) {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supabaseId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.supabaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> settingsRefs(
    Expression<bool> Function($$SettingsTableFilterComposer f) f,
  ) {
    final $$SettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.settings,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettingsTableFilterComposer(
            $db: $db,
            $table: $db.settings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer extends Composer<_$Database, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supabaseId => $composableBuilder(
    column: $table.supabaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGuest => $composableBuilder(
    column: $table.isGuest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLoggedIn => $composableBuilder(
    column: $table.lastLoggedIn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer extends Composer<_$Database, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get supabaseId => $composableBuilder(
    column: $table.supabaseId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isGuest =>
      $composableBuilder(column: $table.isGuest, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoggedIn => $composableBuilder(
    column: $table.lastLoggedIn,
    builder: (column) => column,
  );

  Expression<T> profilesRefs<T extends Object>(
    Expression<T> Function($$ProfilesTableAnnotationComposer a) f,
  ) {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supabaseId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.supabaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> settingsRefs<T extends Object>(
    Expression<T> Function($$SettingsTableAnnotationComposer a) f,
  ) {
    final $$SettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.settings,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.settings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$Database,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool profilesRefs, bool settingsRefs})
        > {
  $$UsersTableTableManager(_$Database db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> supabaseId = const Value.absent(),
                Value<bool> isGuest = const Value.absent(),
                Value<DateTime> lastLoggedIn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                localId: localId,
                supabaseId: supabaseId,
                isGuest: isGuest,
                lastLoggedIn: lastLoggedIn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> supabaseId = const Value.absent(),
                Value<bool> isGuest = const Value.absent(),
                Value<DateTime> lastLoggedIn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                localId: localId,
                supabaseId: supabaseId,
                isGuest: isGuest,
                lastLoggedIn: lastLoggedIn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({profilesRefs = false, settingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (profilesRefs) db.profiles,
                    if (settingsRefs) db.settings,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (profilesRefs)
                        await $_getPrefetchedData<User, $UsersTable, Profile>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._profilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).profilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.supabaseId == item.supabaseId,
                              ),
                          typedResults: items,
                        ),
                      if (settingsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Setting>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._settingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).settingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.localId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool profilesRefs, bool settingsRefs})
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String supabaseId,
      required String username,
      Value<String?> email,
      Value<String?> avatarUrl,
      Value<bool> verified,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> supabaseId,
      Value<String> username,
      Value<String?> email,
      Value<String?> avatarUrl,
      Value<bool> verified,
      Value<int> rowid,
    });

final class $$ProfilesTableReferences
    extends BaseReferences<_$Database, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _supabaseIdTable(_$Database db) => db.users.createAlias(
    $_aliasNameGenerator(db.profiles.supabaseId, db.users.supabaseId),
  );

  $$UsersTableProcessedTableManager get supabaseId {
    final $_column = $_itemColumn<String>('supabase_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.supabaseId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supabaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$Database, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get supabaseId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supabaseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.supabaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$Database, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get supabaseId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supabaseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.supabaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$Database, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  $$UsersTableAnnotationComposer get supabaseId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supabaseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.supabaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$Database,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, $$ProfilesTableReferences),
          Profile,
          PrefetchHooks Function({bool supabaseId})
        > {
  $$ProfilesTableTableManager(_$Database db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> supabaseId = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                supabaseId: supabaseId,
                username: username,
                email: email,
                avatarUrl: avatarUrl,
                verified: verified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String supabaseId,
                required String username,
                Value<String?> email = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                supabaseId: supabaseId,
                username: username,
                email: email,
                avatarUrl: avatarUrl,
                verified: verified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supabaseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (supabaseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.supabaseId,
                                referencedTable: $$ProfilesTableReferences
                                    ._supabaseIdTable(db),
                                referencedColumn: $$ProfilesTableReferences
                                    ._supabaseIdTable(db)
                                    .supabaseId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, $$ProfilesTableReferences),
      Profile,
      PrefetchHooks Function({bool supabaseId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      required String localId,
      Value<bool> darkMode,
      Value<bool> receiveNotifications,
      Value<bool> autoSync,
      Value<bool> autoUpdate,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<bool> darkMode,
      Value<bool> receiveNotifications,
      Value<bool> autoSync,
      Value<bool> autoUpdate,
    });

final class $$SettingsTableReferences
    extends BaseReferences<_$Database, $SettingsTable, Setting> {
  $$SettingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _localIdTable(_$Database db) => db.users.createAlias(
    $_aliasNameGenerator(db.settings.localId, db.users.localId),
  );

  $$UsersTableProcessedTableManager get localId {
    final $_column = $_itemColumn<String>('local_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.localId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SettingsTableFilterComposer
    extends Composer<_$Database, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get receiveNotifications => $composableBuilder(
    column: $table.receiveNotifications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoSync => $composableBuilder(
    column: $table.autoSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoUpdate => $composableBuilder(
    column: $table.autoUpdate,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get localId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettingsTableOrderingComposer
    extends Composer<_$Database, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get receiveNotifications => $composableBuilder(
    column: $table.receiveNotifications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoSync => $composableBuilder(
    column: $table.autoSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoUpdate => $composableBuilder(
    column: $table.autoUpdate,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get localId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$Database, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);

  GeneratedColumn<bool> get receiveNotifications => $composableBuilder(
    column: $table.receiveNotifications,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoSync =>
      $composableBuilder(column: $table.autoSync, builder: (column) => column);

  GeneratedColumn<bool> get autoUpdate => $composableBuilder(
    column: $table.autoUpdate,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get localId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$Database,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, $$SettingsTableReferences),
          Setting,
          PrefetchHooks Function({bool localId})
        > {
  $$SettingsTableTableManager(_$Database db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<bool> darkMode = const Value.absent(),
                Value<bool> receiveNotifications = const Value.absent(),
                Value<bool> autoSync = const Value.absent(),
                Value<bool> autoUpdate = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                localId: localId,
                darkMode: darkMode,
                receiveNotifications: receiveNotifications,
                autoSync: autoSync,
                autoUpdate: autoUpdate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                Value<bool> darkMode = const Value.absent(),
                Value<bool> receiveNotifications = const Value.absent(),
                Value<bool> autoSync = const Value.absent(),
                Value<bool> autoUpdate = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                localId: localId,
                darkMode: darkMode,
                receiveNotifications: receiveNotifications,
                autoSync: autoSync,
                autoUpdate: autoUpdate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({localId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (localId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.localId,
                                referencedTable: $$SettingsTableReferences
                                    ._localIdTable(db),
                                referencedColumn: $$SettingsTableReferences
                                    ._localIdTable(db)
                                    .localId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, $$SettingsTableReferences),
      Setting,
      PrefetchHooks Function({bool localId})
    >;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
