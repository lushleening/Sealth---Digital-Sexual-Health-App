import 'package:drift/drift.dart';

// This file records all sqlite tables
// Default options are set in local db ONLY, to enforce one source of truth
// Note: Primary are not-nullable, Unique are nullable, thus Primary != Unique
// Note: Remember to also add to @DriftDatabase(tables: [...]) in database.dart, otherwise the db won't initialize the column

// To log all guests and registered users
class Users extends Table {
  // Offline use
  TextColumn get localId => text()();

  // Online use
  TextColumn get remoteId => text().nullable().unique()();

  // For UI display
  DateTimeColumn get previousLoggedIn =>
      dateTime().withDefault(Variable(DateTime.now()))();
  DateTimeColumn get currentLoggedIn =>
      dateTime().withDefault(Variable(DateTime.now()))();

  @override
  Set<Column<Object>>? get primaryKey => {localId};

  // @override
  // List<String> get customConstraints => ['UNIQUE (isGuest) WHERE isGuest = 1'];
}

// Only registered users have profiles
// Handle profile creation after register
// This serves as local cache in case of network issues
class Profiles extends Table {
  TextColumn get remoteId =>
      text().references(Users, #remoteId, onDelete: KeyAction.cascade)();
  TextColumn get username => text()();

  // We use supabase storage buckets
  TextColumn get avatarUrl => text().nullable()();

  // Verified users (medical professionals) can:
  // 1. Chat in discussion page with a tick tag on like Twitter (given not an anonymous post)
  // 2. Upload articles
  BoolColumn get verified => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {remoteId};
}

// For all users to change their preferences
class Settings extends Table {
  TextColumn get localId =>
      text().references(Users, #localId, onDelete: KeyAction.cascade)();

  // Depends on user preference
  BoolColumn get darkMode => boolean().withDefault(const Constant(false))();

  // Non-forcing to users if they choose not to receive notifications
  BoolColumn get receiveNotifications =>
      boolean().withDefault(const Constant(true))();

  // Improves app safety
  BoolColumn get biometricConfirmation => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {localId};
}

// Notifications
class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localId =>
      text().references(Users, #localId, onDelete: KeyAction.cascade)();
  TextColumn get icon => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get linkToPageMain => text()();
  TextColumn get linkToPageSub => text().nullable()();
  BoolColumn get alert => boolean().withDefault(const Constant(false))();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  DateTimeColumn get pushDateTime => dateTime()();
  TextColumn get pushTarget => text()(); // TODO List of uid
}

// Sync local -> remote db
class SyncQueue extends Table {
  TextColumn get remoteId =>
      text().references(Users, #remoteId, onDelete: KeyAction.cascade)();
  TextColumn get targetTableName => text()();

  @override
  Set<Column> get primaryKey => {remoteId, targetTableName};
}