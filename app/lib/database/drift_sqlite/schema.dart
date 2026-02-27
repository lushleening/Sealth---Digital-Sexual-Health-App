// CODEGEN RELATED: "dart run build_runner watch"
// This file records all sqlite tables
import 'package:drift/drift.dart';

// To log all guests and registered users
class Users extends Table {
  // Offline use
  TextColumn get localId => text()();

  // Online use
  TextColumn get supabaseId => text().nullable().unique()();

  // Since sqlite could not enforce unique nulls, this is to ensure only one guest is created per device
  BoolColumn get isGuest => boolean().withDefault(const Constant(false))();

  // For session control
  DateTimeColumn get lastLoggedIn =>
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
  TextColumn get supabaseId =>
      text().references(Users, #supabaseId, onDelete: KeyAction.cascade)();
  TextColumn get username => text()();

  TextColumn get email => text().nullable()();

  // We use supabase storage buckets
  TextColumn get avatarUrl => text().nullable()();

  // Verified users can chat with a tag on (given not an anonymous post)
  BoolColumn get verified => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {supabaseId};
}

// TODO settings persistence within app login
// For all users to change their preferences
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localId =>
      text().references(Users, #localId, onDelete: KeyAction.cascade)();

  // Depends on user preference
  BoolColumn get darkMode => boolean().withDefault(const Constant(false))();

  // Non-forcing to users if they choose not to receive
  BoolColumn get receiveNotifications =>
      boolean().withDefault(const Constant(true))();

  // Compliance with privacy
  BoolColumn get autoSync => boolean().withDefault(const Constant(false))();

  // Provide a choice to opt for safety or privacy
  BoolColumn get autoUpdate => boolean().withDefault(const Constant(true))();
}

// TODO
// final userId = supabase.auth.currentUser!.id;

// final file = File(imagePath);

// await supabase.storage
//   .from('avatars')
//   .upload(
//     '$userId/avatar.png',
//     file,
//     fileOptions: const FileOptions(upsert: true),
//   );
