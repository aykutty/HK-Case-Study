import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorDialog({
  required String title,
  required String message,
}) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Tamam'),
        ),
      ],
    ),
  );
}
