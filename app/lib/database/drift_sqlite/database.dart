// CODEGEN RELATED: "dart run build_runner watch"
// This file opens the database for users, but use DatabaseNotifier to access it instead
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sddp_dsh/database/drift_sqlite/schema.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Users, Profiles, Settings])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => await m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from >= 1 && to < 2) {
        // Some migration methods for persistence, this
        // Remember when changing this:
        // 1. Declare the column in respective tables in schema.dart
        // 2. Write what you have edited here
        // 3. Edit the migrationNumber (from >= x && to < y) and the schemaVersion
        // Ignore this if you're using database.memory()

        // await m.addColumn(Settings, settings.someField);
      }
    },
  );
}

// Opens a local sqlite database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    dbLogger.info("Opening database...");

    // Does not persist database during debug mode for debugging and testing
    if (kDebugMode) return NativeDatabase.memory();

    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, "test.db"));
    return NativeDatabase(file);
  });
}
