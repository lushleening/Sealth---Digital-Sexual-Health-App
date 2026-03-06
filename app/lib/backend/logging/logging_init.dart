// Inits logging
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sddp_dsh/backend/constants/log.dart';

void loggingInit() {
  Logger.root.level = kDebugMode ? debugLogLevel : releaseLogLevel;
}
