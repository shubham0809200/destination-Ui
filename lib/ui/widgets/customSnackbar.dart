import 'package:flutter/material.dart';

SnackBar snackbarMessage(String message) {
  return SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  );
}
