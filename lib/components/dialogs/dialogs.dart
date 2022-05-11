import 'dart:io';
import 'package:fiszkomaniak/components/dialogs/confirmation_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/message_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/simple_loading_dialog.dart';
import 'package:fiszkomaniak/components/dialogs/single_input_dialog.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:flutter/material.dart';
import '../../config/slide_up_route_animation.dart';
import 'image_confirmation_dialog.dart';

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

  Future<bool?> askForImageConfirmation({
    required File imageFile,
  }) async {
    final BuildContext? context = HomeRouter.navigatorKey.currentContext;
    if (context != null) {
      return await Navigator.of(context).push(SlideUpRouteAnimation(
        page: ImageConfirmationDialog(imageFile: imageFile),
      ));
    }
    return null;
  }

  Future<String?> askForValue({
    required String title,
    required IconData textFieldIcon,
    required String textFieldLabel,
    required String buttonLabel,
    String? value,
    String? placeholder,
    String? Function(String? value)? validator,
  }) async {
    final BuildContext? context = HomeRouter.navigatorKey.currentContext;
    if (context != null) {
      return await Navigator.of(context).push(SlideUpRouteAnimation(
        page: SingleInputDialog(
          title: title,
          textFieldIcon: textFieldIcon,
          textFieldLabel: textFieldLabel,
          buttonLabel: buttonLabel,
          value: value,
          placeholder: placeholder,
          validator: validator,
        ),
      ));
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
