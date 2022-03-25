import 'package:fiszkomaniak/components/dialogs/message_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/simple_loading_dialog.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog({
    required BuildContext context,
    String? text,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimpleLoadingDialog(text: text),
    );
  }

  static Future<void> showDialogWithMessage({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MessageDialog(title: title, message: message),
    );
  }

  static void showSnackbarWithMessage({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
