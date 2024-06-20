import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  static success(BuildContext context, {String? title, String? description}) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      alignment: Alignment.bottomRight,
      title: Text(title ?? 'Success!'),
      description: description != null ? Text(description) : null,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static error(BuildContext context, {String? title, String? description}) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      alignment: Alignment.bottomRight,
      title: Text(title ?? 'Error!'),
      description: description != null ? Text(description) : null,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static warning(BuildContext context, {String? title, String? description}) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      alignment: Alignment.bottomRight,
      title: Text(title ?? 'Warning!'),
      description: description != null ? Text(description) : null,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}
