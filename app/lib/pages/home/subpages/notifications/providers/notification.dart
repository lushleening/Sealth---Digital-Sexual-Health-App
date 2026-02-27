// CODEGEN RELATED: "dart run build_runner watch"
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sddp_dsh/nav/main_page_route.dart';

part 'notification.freezed.dart';

// Notifications of the app, brings users to the main page, then subpage also (if exists)
// The warning variable describes the urgency of message, will change UI based on it
// The read variable checks if the user has read the notification and will change UI based on it

// This function is totally reliant on supabase
@freezed
abstract class NotificationObj with _$NotificationObj {
  const factory NotificationObj({
    required IconData icon,
    required String title,
    required String description,
    @Default(false) bool warning,
    required MainPageRoute linkToPageMainIndex,
    Widget? linkToPageSub, // TODO give me a way to display your pages
    @Default(false) bool read,
  }) = _NotificationObj;
}

// TODO required bool warning,
// required bool read,
