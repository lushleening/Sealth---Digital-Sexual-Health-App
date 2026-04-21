import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

// This file records all sqlite tables
// Default options are set in local db ONLY (unless table serves as cache from remotely generated data),
// to enforce one source of truth
// Note: Primary are not-nullable, Unique are nullable, thus Primary != Unique
// Note: Remember to also add to @DriftDatabase(tables: [...]) in database.dart, otherwise the db won't initialize the column

// To log all guests and registered users
class Users extends Table {
  // Offline use
  TextColumn get localId => text().clientDefault(() => const Uuid().v4())();

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
  TextColumn get username => text().unique()();

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
  BoolColumn get biometricConfirmation =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {localId};
}

// Notifications
class Notifications extends Table {
  // For local_notification use
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();

  // Since guests won't be synced, we need to save the localId instead (using usersRepo or appUser to map to/from remoteId)
  // Null values mean for all users (for notification page read)
  TextColumn get localId => text().nullable().references(
    Users,
    #localId,
    onDelete: KeyAction.cascade,
  )();

  // Display texts
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();

  // This determines the in-app notification icon shown (used by notification page)
  TextColumn get notificationType => text()();

  // Determines the importance of message
  BoolColumn get isAlertMessage =>
      boolean().withDefault(const Constant(false))();
  // Used by notification page
  BoolColumn get hasRead => boolean().withDefault(const Constant(false))();

  // Which page the notification would link to (use absolute path from /)
  TextColumn get linkToPage => text().withDefault(const Constant('/'))();

  // What time would the notification be released
  DateTimeColumn get scheduledAt =>
      dateTime().withDefault(Variable(DateTime.now()))();

  // For soft delete (no sync from realtime service)
  BoolColumn get hasRemoved => boolean().withDefault(const Constant(false))();
  
  // For offline sync
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(Variable(DateTime.now()))();

  @override
  Set<Column> get primaryKey => {uuid};
}

// Clinics
class CachedClinics extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  DateTimeColumn get lastSynced =>
      dateTime().withDefault(Variable(DateTime.now()))();

  @override
  Set<Column> get primaryKey => {id};
}

// Services
class CachedServices extends Table {
  TextColumn get id => text()();
  TextColumn get clinicId => text()();
  TextColumn get name => text()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(30))();
  DateTimeColumn get lastSynced =>
      dateTime().withDefault(Variable(DateTime.now()))();

  @override
  Set<Column> get primaryKey => {id};
}

// Appointment
class CachedAppointments extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #localId, onDelete: KeyAction.cascade)();
  TextColumn get clinicId => text()();
  TextColumn get serviceId => text()();
  TextColumn get clinicName => text()();
  TextColumn get serviceName => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get lastSynced =>
      dateTime().withDefault(Variable(DateTime.now()))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Recently viewed articles — persists continue-reading history per user
class RecentlyViewedArticles extends Table {
  TextColumn get localId =>
      text().references(Users, #localId, onDelete: KeyAction.cascade)();

  // The Supabase article ID
  TextColumn get articleId => text()();

  // Used to sort by most recently viewed
  DateTimeColumn get viewedAt =>
      dateTime().withDefault(Variable(DateTime.now()))();

  @override
  Set<Column> get primaryKey => {localId, articleId};
}

// Sync local -> remote db
class SyncQueue extends Table {
  TextColumn get remoteId =>
      text().references(Users, #remoteId, onDelete: KeyAction.cascade)();
  TextColumn get targetTableName => text()();

  @override
  Set<Column> get primaryKey => {remoteId, targetTableName};
}
