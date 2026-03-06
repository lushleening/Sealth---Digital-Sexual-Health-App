import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Extend this for your use
class Appointment {
  final String name;
  final String description;
  final DateTime datetime;
  final Widget linkToSubpage;

  Appointment({
    required this.name,
    required this.description,
    required this.datetime,
    required this.linkToSubpage,
  });

  // Example: "14 Dec 2025"
  String get dateString {
    return DateFormat('dd MMM yyyy').format(datetime);
  }

  // Example: "Sunday, 17:08"
  String get timeString {
    return DateFormat('EEEE, h.mm a').format(datetime);
  }
}
