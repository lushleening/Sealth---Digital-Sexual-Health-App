import 'package:flutter/material.dart';

// Snackbox (popup at bottom)
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void showSnackbarMessage(String text) => scaffoldMessengerKey.currentState
    ?.showSnackBar(SnackBar(content: Text(text)));
