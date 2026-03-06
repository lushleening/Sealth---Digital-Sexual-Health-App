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
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _previousLoggedInMeta = const VerificationMeta(
    'previousLoggedIn',
  );
  @override
  late final GeneratedColumn<DateTime> previousLoggedIn =
      GeneratedColumn<DateTime>(
        'previous_logged_in',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: Variable(DateTime.now()),
      );
  static const VerificationMeta _currentLoggedInMeta = const VerificationMeta(
    'currentLoggedIn',
  );
  @override
  late final GeneratedColumn<DateTime> currentLoggedIn =
      GeneratedColumn<DateTime>(
        'current_logged_in',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: Variable(DateTime.now()),
      );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    previousLoggedIn,
    currentLoggedIn,
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
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('previous_logged_in')) {
      context.handle(
        _previousLoggedInMeta,
        previousLoggedIn.isAcceptableOrUnknown(
          data['previous_logged_in']!,
          _previousLoggedInMeta,
        ),
      );
    }
    if (data.containsKey('current_logged_in')) {
      context.handle(
        _currentLoggedInMeta,
        currentLoggedIn.isAcceptableOrUnknown(
          data['current_logged_in']!,
          _currentLoggedInMeta,
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
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      previousLoggedIn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}previous_logged_in'],
      )!,
      currentLoggedIn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}current_logged_in'],
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
  final String? remoteId;
  final DateTime previousLoggedIn;
  final DateTime currentLoggedIn;
  const User({
    required this.localId,
    this.remoteId,
    required this.previousLoggedIn,
    required this.currentLoggedIn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['previous_logged_in'] = Variable<DateTime>(previousLoggedIn);
    map['current_logged_in'] = Variable<DateTime>(currentLoggedIn);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      previousLoggedIn: Value(previousLoggedIn),
      currentLoggedIn: Value(currentLoggedIn),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      previousLoggedIn: serializer.fromJson<DateTime>(json['previousLoggedIn']),
      currentLoggedIn: serializer.fromJson<DateTime>(json['currentLoggedIn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'previousLoggedIn': serializer.toJson<DateTime>(previousLoggedIn),
      'currentLoggedIn': serializer.toJson<DateTime>(currentLoggedIn),
    };
  }

  User copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    DateTime? previousLoggedIn,
    DateTime? currentLoggedIn,
  }) => User(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    previousLoggedIn: previousLoggedIn ?? this.previousLoggedIn,
    currentLoggedIn: currentLoggedIn ?? this.currentLoggedIn,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      previousLoggedIn: data.previousLoggedIn.present
          ? data.previousLoggedIn.value
          : this.previousLoggedIn,
      currentLoggedIn: data.currentLoggedIn.present
          ? data.currentLoggedIn.value
          : this.currentLoggedIn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('previousLoggedIn: $previousLoggedIn, ')
          ..write('currentLoggedIn: $currentLoggedIn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(localId, remoteId, previousLoggedIn, currentLoggedIn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.previousLoggedIn == this.previousLoggedIn &&
          other.currentLoggedIn == this.currentLoggedIn);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<DateTime> previousLoggedIn;
  final Value<DateTime> currentLoggedIn;
  final Value<int> rowid;
  const UsersCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.previousLoggedIn = const Value.absent(),
    this.currentLoggedIn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String localId,
    this.remoteId = const Value.absent(),
    this.previousLoggedIn = const Value.absent(),
    this.currentLoggedIn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId);
  static Insertable<User> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<DateTime>? previousLoggedIn,
    Expression<DateTime>? currentLoggedIn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (previousLoggedIn != null) 'previous_logged_in': previousLoggedIn,
      if (currentLoggedIn != null) 'current_logged_in': currentLoggedIn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<DateTime>? previousLoggedIn,
    Value<DateTime>? currentLoggedIn,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      previousLoggedIn: previousLoggedIn ?? this.previousLoggedIn,
      currentLoggedIn: currentLoggedIn ?? this.currentLoggedIn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (previousLoggedIn.present) {
      map['previous_logged_in'] = Variable<DateTime>(previousLoggedIn.value);
    }
    if (currentLoggedIn.present) {
      map['current_logged_in'] = Variable<DateTime>(currentLoggedIn.value);
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
          ..write('remoteId: $remoteId, ')
          ..write('previousLoggedIn: $previousLoggedIn, ')
          ..write('currentLoggedIn: $currentLoggedIn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (remote_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetTableNameMeta = const VerificationMeta(
    'targetTableName',
  );
  @override
  late final GeneratedColumn<String> targetTableName = GeneratedColumn<String>(
    'target_table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [remoteId, targetTableName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('target_table_name')) {
      context.handle(
        _targetTableNameMeta,
        targetTableName.isAcceptableOrUnknown(
          data['target_table_name']!,
          _targetTableNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {remoteId, targetTableName};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      targetTableName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table_name'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String remoteId;
  final String targetTableName;
  const SyncQueueData({required this.remoteId, required this.targetTableName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['remote_id'] = Variable<String>(remoteId);
    map['target_table_name'] = Variable<String>(targetTableName);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      remoteId: Value(remoteId),
      targetTableName: Value(targetTableName),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      remoteId: serializer.fromJson<String>(json['remoteId']),
      targetTableName: serializer.fromJson<String>(json['targetTableName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'remoteId': serializer.toJson<String>(remoteId),
      'targetTableName': serializer.toJson<String>(targetTableName),
    };
  }

  SyncQueueData copyWith({String? remoteId, String? targetTableName}) =>
      SyncQueueData(
        remoteId: remoteId ?? this.remoteId,
        targetTableName: targetTableName ?? this.targetTableName,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      targetTableName: data.targetTableName.present
          ? data.targetTableName.value
          : this.targetTableName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('remoteId: $remoteId, ')
          ..write('targetTableName: $targetTableName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(remoteId, targetTableName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.remoteId == this.remoteId &&
          other.targetTableName == this.targetTableName);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> remoteId;
  final Value<String> targetTableName;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.remoteId = const Value.absent(),
    this.targetTableName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String remoteId,
    required String targetTableName,
    this.rowid = const Value.absent(),
  }) : remoteId = Value(remoteId),
       targetTableName = Value(targetTableName);
  static Insertable<SyncQueueData> custom({
    Expression<String>? remoteId,
    Expression<String>? targetTableName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (remoteId != null) 'remote_id': remoteId,
      if (targetTableName != null) 'target_table_name': targetTableName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? remoteId,
    Value<String>? targetTableName,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      remoteId: remoteId ?? this.remoteId,
      targetTableName: targetTableName ?? this.targetTableName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (targetTableName.present) {
      map['target_table_name'] = Variable<String>(targetTableName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('remoteId: $remoteId, ')
          ..write('targetTableName: $targetTableName, ')
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
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (remote_id) ON DELETE CASCADE',
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
    remoteId,
    username,
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
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
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
  Set<GeneratedColumn> get $primaryKey => {remoteId};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
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
  final String remoteId;
  final String username;
  final String? avatarUrl;
  final bool verified;
  const Profile({
    required this.remoteId,
    required this.username,
    this.avatarUrl,
    required this.verified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['remote_id'] = Variable<String>(remoteId);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['verified'] = Variable<bool>(verified);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      remoteId: Value(remoteId),
      username: Value(username),
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
      remoteId: serializer.fromJson<String>(json['remoteId']),
      username: serializer.fromJson<String>(json['username']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      verified: serializer.fromJson<bool>(json['verified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'remoteId': serializer.toJson<String>(remoteId),
      'username': serializer.toJson<String>(username),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'verified': serializer.toJson<bool>(verified),
    };
  }

  Profile copyWith({
    String? remoteId,
    String? username,
    Value<String?> avatarUrl = const Value.absent(),
    bool? verified,
  }) => Profile(
    remoteId: remoteId ?? this.remoteId,
    username: username ?? this.username,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    verified: verified ?? this.verified,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      username: data.username.present ? data.username.value : this.username,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      verified: data.verified.present ? data.verified.value : this.verified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('remoteId: $remoteId, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('verified: $verified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(remoteId, username, avatarUrl, verified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.remoteId == this.remoteId &&
          other.username == this.username &&
          other.avatarUrl == this.avatarUrl &&
          other.verified == this.verified);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> remoteId;
  final Value<String> username;
  final Value<String?> avatarUrl;
  final Value<bool> verified;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.remoteId = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.verified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String remoteId,
    required String username,
    this.avatarUrl = const Value.absent(),
    this.verified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : remoteId = Value(remoteId),
       username = Value(username);
  static Insertable<Profile> custom({
    Expression<String>? remoteId,
    Expression<String>? username,
    Expression<String>? avatarUrl,
    Expression<bool>? verified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (remoteId != null) 'remote_id': remoteId,
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (verified != null) 'verified': verified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? remoteId,
    Value<String>? username,
    Value<String?>? avatarUrl,
    Value<bool>? verified,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      remoteId: remoteId ?? this.remoteId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      verified: verified ?? this.verified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
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
          ..write('remoteId: $remoteId, ')
          ..write('username: $username, ')
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
    localId,
    darkMode,
    receiveNotifications,
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
    if (data.containsKey('auto_update')) {
      context.handle(
        _autoUpdateMeta,
        autoUpdate.isAcceptableOrUnknown(data['auto_update']!, _autoUpdateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
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
  final String localId;
  final bool darkMode;
  final bool receiveNotifications;
  final bool autoUpdate;
  const Setting({
    required this.localId,
    required this.darkMode,
    required this.receiveNotifications,
    required this.autoUpdate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['dark_mode'] = Variable<bool>(darkMode);
    map['receive_notifications'] = Variable<bool>(receiveNotifications);
    map['auto_update'] = Variable<bool>(autoUpdate);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      localId: Value(localId),
      darkMode: Value(darkMode),
      receiveNotifications: Value(receiveNotifications),
      autoUpdate: Value(autoUpdate),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      localId: serializer.fromJson<String>(json['localId']),
      darkMode: serializer.fromJson<bool>(json['darkMode']),
      receiveNotifications: serializer.fromJson<bool>(
        json['receiveNotifications'],
      ),
      autoUpdate: serializer.fromJson<bool>(json['autoUpdate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'darkMode': serializer.toJson<bool>(darkMode),
      'receiveNotifications': serializer.toJson<bool>(receiveNotifications),
      'autoUpdate': serializer.toJson<bool>(autoUpdate),
    };
  }

  Setting copyWith({
    String? localId,
    bool? darkMode,
    bool? receiveNotifications,
    bool? autoUpdate,
  }) => Setting(
    localId: localId ?? this.localId,
    darkMode: darkMode ?? this.darkMode,
    receiveNotifications: receiveNotifications ?? this.receiveNotifications,
    autoUpdate: autoUpdate ?? this.autoUpdate,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      localId: data.localId.present ? data.localId.value : this.localId,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
      receiveNotifications: data.receiveNotifications.present
          ? data.receiveNotifications.value
          : this.receiveNotifications,
      autoUpdate: data.autoUpdate.present
          ? data.autoUpdate.value
          : this.autoUpdate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('localId: $localId, ')
          ..write('darkMode: $darkMode, ')
          ..write('receiveNotifications: $receiveNotifications, ')
          ..write('autoUpdate: $autoUpdate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(localId, darkMode, receiveNotifications, autoUpdate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.localId == this.localId &&
          other.darkMode == this.darkMode &&
          other.receiveNotifications == this.receiveNotifications &&
          other.autoUpdate == this.autoUpdate);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> localId;
  final Value<bool> darkMode;
  final Value<bool> receiveNotifications;
  final Value<bool> autoUpdate;
  final Value<int> rowid;
  const SettingsCompanion({
    this.localId = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.receiveNotifications = const Value.absent(),
    this.autoUpdate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String localId,
    this.darkMode = const Value.absent(),
    this.receiveNotifications = const Value.absent(),
    this.autoUpdate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId);
  static Insertable<Setting> custom({
    Expression<String>? localId,
    Expression<bool>? darkMode,
    Expression<bool>? receiveNotifications,
    Expression<bool>? autoUpdate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (darkMode != null) 'dark_mode': darkMode,
      if (receiveNotifications != null)
        'receive_notifications': receiveNotifications,
      if (autoUpdate != null) 'auto_update': autoUpdate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? localId,
    Value<bool>? darkMode,
    Value<bool>? receiveNotifications,
    Value<bool>? autoUpdate,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      localId: localId ?? this.localId,
      darkMode: darkMode ?? this.darkMode,
      receiveNotifications: receiveNotifications ?? this.receiveNotifications,
      autoUpdate: autoUpdate ?? this.autoUpdate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    if (receiveNotifications.present) {
      map['receive_notifications'] = Variable<bool>(receiveNotifications.value);
    }
    if (autoUpdate.present) {
      map['auto_update'] = Variable<bool>(autoUpdate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('localId: $localId, ')
          ..write('darkMode: $darkMode, ')
          ..write('receiveNotifications: $receiveNotifications, ')
          ..write('autoUpdate: $autoUpdate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, Notification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _linkToPageMainMeta = const VerificationMeta(
    'linkToPageMain',
  );
  @override
  late final GeneratedColumn<String> linkToPageMain = GeneratedColumn<String>(
    'link_to_page_main',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkToPageSubMeta = const VerificationMeta(
    'linkToPageSub',
  );
  @override
  late final GeneratedColumn<String> linkToPageSub = GeneratedColumn<String>(
    'link_to_page_sub',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alertMeta = const VerificationMeta('alert');
  @override
  late final GeneratedColumn<bool> alert = GeneratedColumn<bool>(
    'alert',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alert" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
    'read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pushDateTimeMeta = const VerificationMeta(
    'pushDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> pushDateTime = GeneratedColumn<DateTime>(
    'push_date_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pushTargetMeta = const VerificationMeta(
    'pushTarget',
  );
  @override
  late final GeneratedColumn<String> pushTarget = GeneratedColumn<String>(
    'push_target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    icon,
    title,
    description,
    linkToPageMain,
    linkToPageSub,
    alert,
    read,
    pushDateTime,
    pushTarget,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Notification> instance, {
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
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('link_to_page_main')) {
      context.handle(
        _linkToPageMainMeta,
        linkToPageMain.isAcceptableOrUnknown(
          data['link_to_page_main']!,
          _linkToPageMainMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_linkToPageMainMeta);
    }
    if (data.containsKey('link_to_page_sub')) {
      context.handle(
        _linkToPageSubMeta,
        linkToPageSub.isAcceptableOrUnknown(
          data['link_to_page_sub']!,
          _linkToPageSubMeta,
        ),
      );
    }
    if (data.containsKey('alert')) {
      context.handle(
        _alertMeta,
        alert.isAcceptableOrUnknown(data['alert']!, _alertMeta),
      );
    }
    if (data.containsKey('read')) {
      context.handle(
        _readMeta,
        read.isAcceptableOrUnknown(data['read']!, _readMeta),
      );
    }
    if (data.containsKey('push_date_time')) {
      context.handle(
        _pushDateTimeMeta,
        pushDateTime.isAcceptableOrUnknown(
          data['push_date_time']!,
          _pushDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pushDateTimeMeta);
    }
    if (data.containsKey('push_target')) {
      context.handle(
        _pushTargetMeta,
        pushTarget.isAcceptableOrUnknown(data['push_target']!, _pushTargetMeta),
      );
    } else if (isInserting) {
      context.missing(_pushTargetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Notification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      linkToPageMain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_to_page_main'],
      )!,
      linkToPageSub: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_to_page_sub'],
      ),
      alert: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alert'],
      )!,
      read: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read'],
      )!,
      pushDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}push_date_time'],
      )!,
      pushTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}push_target'],
      )!,
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }
}

class Notification extends DataClass implements Insertable<Notification> {
  final int id;
  final String localId;
  final String icon;
  final String title;
  final String description;
  final String linkToPageMain;
  final String? linkToPageSub;
  final bool alert;
  final bool read;
  final DateTime pushDateTime;
  final String pushTarget;
  const Notification({
    required this.id,
    required this.localId,
    required this.icon,
    required this.title,
    required this.description,
    required this.linkToPageMain,
    this.linkToPageSub,
    required this.alert,
    required this.read,
    required this.pushDateTime,
    required this.pushTarget,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    map['icon'] = Variable<String>(icon);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['link_to_page_main'] = Variable<String>(linkToPageMain);
    if (!nullToAbsent || linkToPageSub != null) {
      map['link_to_page_sub'] = Variable<String>(linkToPageSub);
    }
    map['alert'] = Variable<bool>(alert);
    map['read'] = Variable<bool>(read);
    map['push_date_time'] = Variable<DateTime>(pushDateTime);
    map['push_target'] = Variable<String>(pushTarget);
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      localId: Value(localId),
      icon: Value(icon),
      title: Value(title),
      description: Value(description),
      linkToPageMain: Value(linkToPageMain),
      linkToPageSub: linkToPageSub == null && nullToAbsent
          ? const Value.absent()
          : Value(linkToPageSub),
      alert: Value(alert),
      read: Value(read),
      pushDateTime: Value(pushDateTime),
      pushTarget: Value(pushTarget),
    );
  }

  factory Notification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notification(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['localId']),
      icon: serializer.fromJson<String>(json['icon']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      linkToPageMain: serializer.fromJson<String>(json['linkToPageMain']),
      linkToPageSub: serializer.fromJson<String?>(json['linkToPageSub']),
      alert: serializer.fromJson<bool>(json['alert']),
      read: serializer.fromJson<bool>(json['read']),
      pushDateTime: serializer.fromJson<DateTime>(json['pushDateTime']),
      pushTarget: serializer.fromJson<String>(json['pushTarget']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localId': serializer.toJson<String>(localId),
      'icon': serializer.toJson<String>(icon),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'linkToPageMain': serializer.toJson<String>(linkToPageMain),
      'linkToPageSub': serializer.toJson<String?>(linkToPageSub),
      'alert': serializer.toJson<bool>(alert),
      'read': serializer.toJson<bool>(read),
      'pushDateTime': serializer.toJson<DateTime>(pushDateTime),
      'pushTarget': serializer.toJson<String>(pushTarget),
    };
  }

  Notification copyWith({
    int? id,
    String? localId,
    String? icon,
    String? title,
    String? description,
    String? linkToPageMain,
    Value<String?> linkToPageSub = const Value.absent(),
    bool? alert,
    bool? read,
    DateTime? pushDateTime,
    String? pushTarget,
  }) => Notification(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    icon: icon ?? this.icon,
    title: title ?? this.title,
    description: description ?? this.description,
    linkToPageMain: linkToPageMain ?? this.linkToPageMain,
    linkToPageSub: linkToPageSub.present
        ? linkToPageSub.value
        : this.linkToPageSub,
    alert: alert ?? this.alert,
    read: read ?? this.read,
    pushDateTime: pushDateTime ?? this.pushDateTime,
    pushTarget: pushTarget ?? this.pushTarget,
  );
  Notification copyWithCompanion(NotificationsCompanion data) {
    return Notification(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      icon: data.icon.present ? data.icon.value : this.icon,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      linkToPageMain: data.linkToPageMain.present
          ? data.linkToPageMain.value
          : this.linkToPageMain,
      linkToPageSub: data.linkToPageSub.present
          ? data.linkToPageSub.value
          : this.linkToPageSub,
      alert: data.alert.present ? data.alert.value : this.alert,
      read: data.read.present ? data.read.value : this.read,
      pushDateTime: data.pushDateTime.present
          ? data.pushDateTime.value
          : this.pushDateTime,
      pushTarget: data.pushTarget.present
          ? data.pushTarget.value
          : this.pushTarget,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Notification(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('icon: $icon, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('linkToPageMain: $linkToPageMain, ')
          ..write('linkToPageSub: $linkToPageSub, ')
          ..write('alert: $alert, ')
          ..write('read: $read, ')
          ..write('pushDateTime: $pushDateTime, ')
          ..write('pushTarget: $pushTarget')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    icon,
    title,
    description,
    linkToPageMain,
    linkToPageSub,
    alert,
    read,
    pushDateTime,
    pushTarget,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notification &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.icon == this.icon &&
          other.title == this.title &&
          other.description == this.description &&
          other.linkToPageMain == this.linkToPageMain &&
          other.linkToPageSub == this.linkToPageSub &&
          other.alert == this.alert &&
          other.read == this.read &&
          other.pushDateTime == this.pushDateTime &&
          other.pushTarget == this.pushTarget);
}

class NotificationsCompanion extends UpdateCompanion<Notification> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String> icon;
  final Value<String> title;
  final Value<String> description;
  final Value<String> linkToPageMain;
  final Value<String?> linkToPageSub;
  final Value<bool> alert;
  final Value<bool> read;
  final Value<DateTime> pushDateTime;
  final Value<String> pushTarget;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.icon = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.linkToPageMain = const Value.absent(),
    this.linkToPageSub = const Value.absent(),
    this.alert = const Value.absent(),
    this.read = const Value.absent(),
    this.pushDateTime = const Value.absent(),
    this.pushTarget = const Value.absent(),
  });
  NotificationsCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    required String icon,
    required String title,
    this.description = const Value.absent(),
    required String linkToPageMain,
    this.linkToPageSub = const Value.absent(),
    this.alert = const Value.absent(),
    this.read = const Value.absent(),
    required DateTime pushDateTime,
    required String pushTarget,
  }) : localId = Value(localId),
       icon = Value(icon),
       title = Value(title),
       linkToPageMain = Value(linkToPageMain),
       pushDateTime = Value(pushDateTime),
       pushTarget = Value(pushTarget);
  static Insertable<Notification> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? icon,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? linkToPageMain,
    Expression<String>? linkToPageSub,
    Expression<bool>? alert,
    Expression<bool>? read,
    Expression<DateTime>? pushDateTime,
    Expression<String>? pushTarget,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (icon != null) 'icon': icon,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (linkToPageMain != null) 'link_to_page_main': linkToPageMain,
      if (linkToPageSub != null) 'link_to_page_sub': linkToPageSub,
      if (alert != null) 'alert': alert,
      if (read != null) 'read': read,
      if (pushDateTime != null) 'push_date_time': pushDateTime,
      if (pushTarget != null) 'push_target': pushTarget,
    });
  }

  NotificationsCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String>? icon,
    Value<String>? title,
    Value<String>? description,
    Value<String>? linkToPageMain,
    Value<String?>? linkToPageSub,
    Value<bool>? alert,
    Value<bool>? read,
    Value<DateTime>? pushDateTime,
    Value<String>? pushTarget,
  }) {
    return NotificationsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
      linkToPageMain: linkToPageMain ?? this.linkToPageMain,
      linkToPageSub: linkToPageSub ?? this.linkToPageSub,
      alert: alert ?? this.alert,
      read: read ?? this.read,
      pushDateTime: pushDateTime ?? this.pushDateTime,
      pushTarget: pushTarget ?? this.pushTarget,
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
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (linkToPageMain.present) {
      map['link_to_page_main'] = Variable<String>(linkToPageMain.value);
    }
    if (linkToPageSub.present) {
      map['link_to_page_sub'] = Variable<String>(linkToPageSub.value);
    }
    if (alert.present) {
      map['alert'] = Variable<bool>(alert.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (pushDateTime.present) {
      map['push_date_time'] = Variable<DateTime>(pushDateTime.value);
    }
    if (pushTarget.present) {
      map['push_target'] = Variable<String>(pushTarget.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('icon: $icon, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('linkToPageMain: $linkToPageMain, ')
          ..write('linkToPageSub: $linkToPageSub, ')
          ..write('alert: $alert, ')
          ..write('read: $read, ')
          ..write('pushDateTime: $pushDateTime, ')
          ..write('pushTarget: $pushTarget')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    syncQueue,
    profiles,
    settings,
    notifications,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sync_queue', kind: UpdateKind.delete)],
    ),
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notifications', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String localId,
      Value<String?> remoteId,
      Value<DateTime> previousLoggedIn,
      Value<DateTime> currentLoggedIn,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<DateTime> previousLoggedIn,
      Value<DateTime> currentLoggedIn,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$Database, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SyncQueueTable, List<SyncQueueData>>
  _syncQueueRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.syncQueue,
    aliasName: $_aliasNameGenerator(db.users.remoteId, db.syncQueue.remoteId),
  );

  $$SyncQueueTableProcessedTableManager get syncQueueRefs {
    final manager = $$SyncQueueTableTableManager($_db, $_db.syncQueue).filter(
      (f) => f.remoteId.remoteId.sqlEquals($_itemColumn<String>('remote_id')),
    );

    final cache = $_typedResult.readTableOrNull(_syncQueueRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProfilesTable, List<Profile>> _profilesRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.profiles,
    aliasName: $_aliasNameGenerator(db.users.remoteId, db.profiles.remoteId),
  );

  $$ProfilesTableProcessedTableManager get profilesRefs {
    final manager = $$ProfilesTableTableManager($_db, $_db.profiles).filter(
      (f) => f.remoteId.remoteId.sqlEquals($_itemColumn<String>('remote_id')),
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

  static MultiTypedResultKey<$NotificationsTable, List<Notification>>
  _notificationsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.notifications,
    aliasName: $_aliasNameGenerator(db.users.localId, db.notifications.localId),
  );

  $$NotificationsTableProcessedTableManager get notificationsRefs {
    final manager = $$NotificationsTableTableManager($_db, $_db.notifications)
        .filter(
          (f) => f.localId.localId.sqlEquals($_itemColumn<String>('local_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_notificationsRefsTable($_db));
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

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get previousLoggedIn => $composableBuilder(
    column: $table.previousLoggedIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get currentLoggedIn => $composableBuilder(
    column: $table.currentLoggedIn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> syncQueueRefs(
    Expression<bool> Function($$SyncQueueTableFilterComposer f) f,
  ) {
    final $$SyncQueueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.syncQueue,
      getReferencedColumn: (t) => t.remoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncQueueTableFilterComposer(
            $db: $db,
            $table: $db.syncQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> profilesRefs(
    Expression<bool> Function($$ProfilesTableFilterComposer f) f,
  ) {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.remoteId,
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

  Expression<bool> notificationsRefs(
    Expression<bool> Function($$NotificationsTableFilterComposer f) f,
  ) {
    final $$NotificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.notifications,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationsTableFilterComposer(
            $db: $db,
            $table: $db.notifications,
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

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get previousLoggedIn => $composableBuilder(
    column: $table.previousLoggedIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get currentLoggedIn => $composableBuilder(
    column: $table.currentLoggedIn,
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

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get previousLoggedIn => $composableBuilder(
    column: $table.previousLoggedIn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get currentLoggedIn => $composableBuilder(
    column: $table.currentLoggedIn,
    builder: (column) => column,
  );

  Expression<T> syncQueueRefs<T extends Object>(
    Expression<T> Function($$SyncQueueTableAnnotationComposer a) f,
  ) {
    final $$SyncQueueTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.syncQueue,
      getReferencedColumn: (t) => t.remoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncQueueTableAnnotationComposer(
            $db: $db,
            $table: $db.syncQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> profilesRefs<T extends Object>(
    Expression<T> Function($$ProfilesTableAnnotationComposer a) f,
  ) {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.remoteId,
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

  Expression<T> notificationsRefs<T extends Object>(
    Expression<T> Function($$NotificationsTableAnnotationComposer a) f,
  ) {
    final $$NotificationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.notifications,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationsTableAnnotationComposer(
            $db: $db,
            $table: $db.notifications,
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
          PrefetchHooks Function({
            bool syncQueueRefs,
            bool profilesRefs,
            bool settingsRefs,
            bool notificationsRefs,
          })
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
                Value<String?> remoteId = const Value.absent(),
                Value<DateTime> previousLoggedIn = const Value.absent(),
                Value<DateTime> currentLoggedIn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                localId: localId,
                remoteId: remoteId,
                previousLoggedIn: previousLoggedIn,
                currentLoggedIn: currentLoggedIn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> remoteId = const Value.absent(),
                Value<DateTime> previousLoggedIn = const Value.absent(),
                Value<DateTime> currentLoggedIn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                previousLoggedIn: previousLoggedIn,
                currentLoggedIn: currentLoggedIn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                syncQueueRefs = false,
                profilesRefs = false,
                settingsRefs = false,
                notificationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (syncQueueRefs) db.syncQueue,
                    if (profilesRefs) db.profiles,
                    if (settingsRefs) db.settings,
                    if (notificationsRefs) db.notifications,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (syncQueueRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          SyncQueueData
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._syncQueueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).syncQueueRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.remoteId == item.remoteId,
                              ),
                          typedResults: items,
                        ),
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
                                (e) => e.remoteId == item.remoteId,
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
                      if (notificationsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          Notification
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._notificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).notificationsRefs,
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
      PrefetchHooks Function({
        bool syncQueueRefs,
        bool profilesRefs,
        bool settingsRefs,
        bool notificationsRefs,
      })
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String remoteId,
      required String targetTableName,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> remoteId,
      Value<String> targetTableName,
      Value<int> rowid,
    });

final class $$SyncQueueTableReferences
    extends BaseReferences<_$Database, $SyncQueueTable, SyncQueueData> {
  $$SyncQueueTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _remoteIdTable(_$Database db) => db.users.createAlias(
    $_aliasNameGenerator(db.syncQueue.remoteId, db.users.remoteId),
  );

  $$UsersTableProcessedTableManager get remoteId {
    final $_column = $_itemColumn<String>('remote_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.remoteId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_remoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncQueueTableFilterComposer
    extends Composer<_$Database, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get targetTableName => $composableBuilder(
    column: $table.targetTableName,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get remoteId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.remoteId,
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

class $$SyncQueueTableOrderingComposer
    extends Composer<_$Database, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get targetTableName => $composableBuilder(
    column: $table.targetTableName,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get remoteId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.remoteId,
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

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$Database, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get targetTableName => $composableBuilder(
    column: $table.targetTableName,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get remoteId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.remoteId,
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

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$Database,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (SyncQueueData, $$SyncQueueTableReferences),
          SyncQueueData,
          PrefetchHooks Function({bool remoteId})
        > {
  $$SyncQueueTableTableManager(_$Database db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> remoteId = const Value.absent(),
                Value<String> targetTableName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                remoteId: remoteId,
                targetTableName: targetTableName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String remoteId,
                required String targetTableName,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                remoteId: remoteId,
                targetTableName: targetTableName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SyncQueueTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({remoteId = false}) {
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
                    if (remoteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.remoteId,
                                referencedTable: $$SyncQueueTableReferences
                                    ._remoteIdTable(db),
                                referencedColumn: $$SyncQueueTableReferences
                                    ._remoteIdTable(db)
                                    .remoteId,
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

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (SyncQueueData, $$SyncQueueTableReferences),
      SyncQueueData,
      PrefetchHooks Function({bool remoteId})
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String remoteId,
      required String username,
      Value<String?> avatarUrl,
      Value<bool> verified,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> remoteId,
      Value<String> username,
      Value<String?> avatarUrl,
      Value<bool> verified,
      Value<int> rowid,
    });

final class $$ProfilesTableReferences
    extends BaseReferences<_$Database, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _remoteIdTable(_$Database db) => db.users.createAlias(
    $_aliasNameGenerator(db.profiles.remoteId, db.users.remoteId),
  );

  $$UsersTableProcessedTableManager get remoteId {
    final $_column = $_itemColumn<String>('remote_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.remoteId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_remoteIdTable($_db));
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

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get remoteId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.remoteId,
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

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get remoteId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.remoteId,
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

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  $$UsersTableAnnotationComposer get remoteId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remoteId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.remoteId,
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
          PrefetchHooks Function({bool remoteId})
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
                Value<String> remoteId = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                remoteId: remoteId,
                username: username,
                avatarUrl: avatarUrl,
                verified: verified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String remoteId,
                required String username,
                Value<String?> avatarUrl = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                remoteId: remoteId,
                username: username,
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
          prefetchHooksCallback: ({remoteId = false}) {
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
                    if (remoteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.remoteId,
                                referencedTable: $$ProfilesTableReferences
                                    ._remoteIdTable(db),
                                referencedColumn: $$ProfilesTableReferences
                                    ._remoteIdTable(db)
                                    .remoteId,
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
      PrefetchHooks Function({bool remoteId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String localId,
      Value<bool> darkMode,
      Value<bool> receiveNotifications,
      Value<bool> autoUpdate,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> localId,
      Value<bool> darkMode,
      Value<bool> receiveNotifications,
      Value<bool> autoUpdate,
      Value<int> rowid,
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
  ColumnFilters<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get receiveNotifications => $composableBuilder(
    column: $table.receiveNotifications,
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
  ColumnOrderings<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get receiveNotifications => $composableBuilder(
    column: $table.receiveNotifications,
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
  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);

  GeneratedColumn<bool> get receiveNotifications => $composableBuilder(
    column: $table.receiveNotifications,
    builder: (column) => column,
  );

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
                Value<String> localId = const Value.absent(),
                Value<bool> darkMode = const Value.absent(),
                Value<bool> receiveNotifications = const Value.absent(),
                Value<bool> autoUpdate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                localId: localId,
                darkMode: darkMode,
                receiveNotifications: receiveNotifications,
                autoUpdate: autoUpdate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<bool> darkMode = const Value.absent(),
                Value<bool> receiveNotifications = const Value.absent(),
                Value<bool> autoUpdate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                localId: localId,
                darkMode: darkMode,
                receiveNotifications: receiveNotifications,
                autoUpdate: autoUpdate,
                rowid: rowid,
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
typedef $$NotificationsTableCreateCompanionBuilder =
    NotificationsCompanion Function({
      Value<int> id,
      required String localId,
      required String icon,
      required String title,
      Value<String> description,
      required String linkToPageMain,
      Value<String?> linkToPageSub,
      Value<bool> alert,
      Value<bool> read,
      required DateTime pushDateTime,
      required String pushTarget,
    });
typedef $$NotificationsTableUpdateCompanionBuilder =
    NotificationsCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String> icon,
      Value<String> title,
      Value<String> description,
      Value<String> linkToPageMain,
      Value<String?> linkToPageSub,
      Value<bool> alert,
      Value<bool> read,
      Value<DateTime> pushDateTime,
      Value<String> pushTarget,
    });

final class $$NotificationsTableReferences
    extends BaseReferences<_$Database, $NotificationsTable, Notification> {
  $$NotificationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _localIdTable(_$Database db) => db.users.createAlias(
    $_aliasNameGenerator(db.notifications.localId, db.users.localId),
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

class $$NotificationsTableFilterComposer
    extends Composer<_$Database, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
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

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkToPageMain => $composableBuilder(
    column: $table.linkToPageMain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkToPageSub => $composableBuilder(
    column: $table.linkToPageSub,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alert => $composableBuilder(
    column: $table.alert,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pushDateTime => $composableBuilder(
    column: $table.pushDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pushTarget => $composableBuilder(
    column: $table.pushTarget,
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

class $$NotificationsTableOrderingComposer
    extends Composer<_$Database, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
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

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkToPageMain => $composableBuilder(
    column: $table.linkToPageMain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkToPageSub => $composableBuilder(
    column: $table.linkToPageSub,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alert => $composableBuilder(
    column: $table.alert,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pushDateTime => $composableBuilder(
    column: $table.pushDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pushTarget => $composableBuilder(
    column: $table.pushTarget,
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

class $$NotificationsTableAnnotationComposer
    extends Composer<_$Database, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkToPageMain => $composableBuilder(
    column: $table.linkToPageMain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkToPageSub => $composableBuilder(
    column: $table.linkToPageSub,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get alert =>
      $composableBuilder(column: $table.alert, builder: (column) => column);

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumn<DateTime> get pushDateTime => $composableBuilder(
    column: $table.pushDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pushTarget => $composableBuilder(
    column: $table.pushTarget,
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

class $$NotificationsTableTableManager
    extends
        RootTableManager<
          _$Database,
          $NotificationsTable,
          Notification,
          $$NotificationsTableFilterComposer,
          $$NotificationsTableOrderingComposer,
          $$NotificationsTableAnnotationComposer,
          $$NotificationsTableCreateCompanionBuilder,
          $$NotificationsTableUpdateCompanionBuilder,
          (Notification, $$NotificationsTableReferences),
          Notification,
          PrefetchHooks Function({bool localId})
        > {
  $$NotificationsTableTableManager(_$Database db, $NotificationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> linkToPageMain = const Value.absent(),
                Value<String?> linkToPageSub = const Value.absent(),
                Value<bool> alert = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<DateTime> pushDateTime = const Value.absent(),
                Value<String> pushTarget = const Value.absent(),
              }) => NotificationsCompanion(
                id: id,
                localId: localId,
                icon: icon,
                title: title,
                description: description,
                linkToPageMain: linkToPageMain,
                linkToPageSub: linkToPageSub,
                alert: alert,
                read: read,
                pushDateTime: pushDateTime,
                pushTarget: pushTarget,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                required String icon,
                required String title,
                Value<String> description = const Value.absent(),
                required String linkToPageMain,
                Value<String?> linkToPageSub = const Value.absent(),
                Value<bool> alert = const Value.absent(),
                Value<bool> read = const Value.absent(),
                required DateTime pushDateTime,
                required String pushTarget,
              }) => NotificationsCompanion.insert(
                id: id,
                localId: localId,
                icon: icon,
                title: title,
                description: description,
                linkToPageMain: linkToPageMain,
                linkToPageSub: linkToPageSub,
                alert: alert,
                read: read,
                pushDateTime: pushDateTime,
                pushTarget: pushTarget,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NotificationsTableReferences(db, table, e),
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
                                referencedTable: $$NotificationsTableReferences
                                    ._localIdTable(db),
                                referencedColumn: $$NotificationsTableReferences
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

typedef $$NotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $NotificationsTable,
      Notification,
      $$NotificationsTableFilterComposer,
      $$NotificationsTableOrderingComposer,
      $$NotificationsTableAnnotationComposer,
      $$NotificationsTableCreateCompanionBuilder,
      $$NotificationsTableUpdateCompanionBuilder,
      (Notification, $$NotificationsTableReferences),
      Notification,
      PrefetchHooks Function({bool localId})
    >;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
}

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
