import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/constants/text_hints.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> uploadAvatar(
  SupabaseClient client,
  File file,
  String remoteId,
) async {
  final fileExt = path.extension(file.path);
  final storagePath =
      '$remoteId$fileExt?v=${DateTime.now().millisecondsSinceEpoch}';
  try {
    storageLogger.fine("Storing image into path $storagePath...");
    await client.storage
        .from(avatarStorageName)
        .upload(storagePath, file, fileOptions: FileOptions(upsert: true));

    storageLogger.fine("Getting public url of stored image in remote storage.");
    return client.storage.from(avatarStorageName).getPublicUrl(storagePath);
  } catch (e) {
    storageLogger.severe(e);
    showSnackbarMessage(unexpectedInformDev);
  }
  return null;
}
