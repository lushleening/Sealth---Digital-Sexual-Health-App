import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:uuid/uuid.dart';

Future<String> getOrInsertEncryptionKey() async {
  final secureStorage = FlutterSecureStorage();
  final existingKey = await secureStorage.read(key: dbKeyName);
  if (existingKey != null) {
    return existingKey;
  }

  // Generate a new secure random key if not found
  final newKey = const Uuid().v4();
  await secureStorage.write(
    key: dbKeyName,
    value: newKey,
  );
  return newKey;
}