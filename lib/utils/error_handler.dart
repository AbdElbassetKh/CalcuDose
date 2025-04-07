import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static void logError(dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      print('Error: $error');
      if (stackTrace != null) print(stackTrace);
    }
    // Add your error reporting service here
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
