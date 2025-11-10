import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../main.dart';

class Toast {
  const Toast();

  static void call({
    BuildContext? context,
    required String title,
    String? description,
    required ToastificationType type,
  }) {
    toastification.show(
      context: context,
      overlayState: navigatorKey.currentState?.overlay,
      type: type,
      title: Text(title),
      style: ToastificationStyle.fillColored,
      alignment: Alignment.bottomCenter,
      borderRadius: BorderRadius.circular(50.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      description: description == null ? null : Text(description),
      animationDuration: const Duration(milliseconds: 300),
      autoCloseDuration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.vertical,
      showProgressBar: true,
      showIcon: true,
    );
  }

  static void i(String title, {BuildContext? context, String? description}) {
    call(
        context: context,
        title: title,
        description: description,
        type: ToastificationType.info);
  }

  static void s(String title, {BuildContext? context, String? description}) {
    call(
        context: context,
        title: title,
        description: description,
        type: ToastificationType.success);
  }

  static void w(String title, {BuildContext? context, String? description}) {
    call(
        context: context,
        title: title,
        description: description,
        type: ToastificationType.warning);
  }

  static void e(String title, {BuildContext? context, String? description}) {
    call(
        context: context,
        title: title,
        description: description,
        type: ToastificationType.error);
  }
}

const showToast = Toast();
