import 'package:fiszkomaniak/components/dialogs/confirmation_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/message_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/simple_loading_dialog.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:flutter/material.dart';

class Dialogs {
  bool _isLoadingDialogOpened = false;

  Future<void> showLoadingDialog({
    BuildContext? context,
    String? loadingText,
  }) async {
    final BuildContext? homeContext = HomeRouter.navigatorKey.currentContext;
    final BuildContext? mainContext = context ?? homeContext;
    if (mainContext != null && !_isLoadingDialogOpened) {
      _isLoadingDialogOpened = true;
      await showDialog(
        context: mainContext,
        barrierDismissible: false,
        builder: (_) => SimpleLoadingDialog(text: loadingText),
      ).then((_) => _isLoadingDialogOpened = false);
    }
  }

  Future<void> showDialogWithMessage({
    required String title,
    required String message,
    BuildContext? context,
  }) async {
    final BuildContext? homeContext = HomeRouter.navigatorKey.currentContext;
    final BuildContext? mainContext = context ?? homeContext;
    if (mainContext != null) {
      await showDialog(
        context: mainContext,
        barrierDismissible: false,
        builder: (_) => MessageDialog(title: title, message: message),
      );
    }
  }

  Future<bool?> askForConfirmation({
    required String title,
    required String text,
    String? confirmButtonText,
    String? cancelButtonText,
  }) async {
    final BuildContext? context = HomeRouter.navigatorKey.currentContext;
    if (context != null) {
      return await showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: title,
          text: text,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
        ),
      );
    }
    return null;
  }

  void showSnackbarWithMessage(String message) {
    final BuildContext? context = HomeRouter.navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}
