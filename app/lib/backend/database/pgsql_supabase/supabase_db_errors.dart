import 'dart:io';

import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void handleSupaDBErrors(Object e) {
  if (e is SocketException) {
    remoteDBLogger.info("Network error while fetching profile: $e");
  } else if (e is PostgrestException) {
    remoteDBLogger.shout("Supabase query failed: ${e.message}");
    throw Exception("Failed to fetch profile due to remote database issues");
  } else {
    remoteDBLogger.severe("Supabase query failed: $e");
    throw e;
  }
}
