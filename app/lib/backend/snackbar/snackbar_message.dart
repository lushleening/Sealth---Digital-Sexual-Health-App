import 'package:flutter/material.dart';

// Snackbox invoker
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void showSnackbarMessage(String text) => scaffoldMessengerKey.currentState
    ?.showSnackBar(SnackBar(content: Text(text)));
