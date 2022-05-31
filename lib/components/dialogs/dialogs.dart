import 'dart:io';
import 'package:fiszkomaniak/components/dialogs/confirmation_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/message_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/simple_loading_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/single_input_dialog/single_input_dialog.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:flutter/material.dart';
import '../../config/slide_up_route_animation.dart';
import 'image_confirmation_dialog.dart';

class Dialogs {
  static bool isLoadingDialogOpened = false;

  static Future<void> showLoadingDialog({
    BuildContext? context,
    String? loadingText,
  }) async {
    final BuildContext? homeContext = navigatorKey.currentContext;
    final BuildContext? mainContext = context ?? homeContext;
    if (mainContext != null && !isLoadingDialogOpened) {
      isLoadingDialogOpened = true;
      await showDialog(
        context: mainContext,
        barrierDismissible: false,
        builder: (_) => SimpleLoadingDialog(text: loadingText),
      ).then((_) => isLoadingDialogOpened = false);
    }
  }

  static void closeLoadingDialog(BuildContext context) {
    if (isLoadingDialogOpened) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  static Future<void> showDialogWithMessage({
    required String title,
    required String message,
    BuildContext? context,
  }) async {
    final BuildContext? homeContext = navigatorKey.currentContext;
    final BuildContext? mainContext = context ?? homeContext;
    if (mainContext != null) {
      await showDialog(
        context: mainContext,
        builder: (_) => MessageDialog(title: title, message: message),
      );
    }
  }

  static Future<void> showErrorDialog({
    required String message,
    BuildContext? context,
  }) async {
    await showDialogWithMessage(
      title: 'Wystąpił błąd...',
      message: message,
      context: context,
    );
  }

  static Future<bool?> askForConfirmation({
    required String title,
    required String text,
    String? confirmButtonText,
    String? cancelButtonText,
  }) async {
    final BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      return await showDialog(
        context: context,
        barrierDismissible: false,
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

  static Future<bool?> askForImageConfirmation({
    required File imageFile,
  }) async {
    final BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      hideSnackbar();
      return await Navigator.of(context).push(SlideUpRouteAnimation(
        page: ImageConfirmationDialog(imageFile: imageFile),
      ));
    }
    return null;
  }

  static Future<String?> askForValue({
    required String appBarTitle,
    required IconData textFieldIcon,
    required TextFieldType textFieldType,
    String? title,
    String? message,
    String? textFieldLabel,
    String? textFieldPlaceholder,
    String? textFieldValue,
    String? submitButtonLabel,
  }) async {
    final BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      hideSnackbar();
      return await Navigator.of(context).push(
        SlideUpRouteAnimation(
          page: SingleInputDialog(
            appBarTitle: appBarTitle,
            textFieldIcon: textFieldIcon,
            textFieldType: textFieldType,
            title: title,
            message: message,
            textFieldLabel: textFieldLabel,
            textFieldPlaceholder: textFieldPlaceholder,
            textFieldValue: textFieldValue,
            submitButtonLabel: submitButtonLabel,
          ),
        ),
      );
    }
    return null;
  }

  static void showSnackbarWithMessage(String message) {
    final BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  static void hideSnackbar() {
    final BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }
}
