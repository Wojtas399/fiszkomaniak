import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardsBlocListener
    extends BlocListener<FlashcardsBloc, FlashcardsState> {
  FlashcardsBlocListener({super.key})
      : super(
          listener: (BuildContext context, FlashcardsState state) {
            final FlashcardsStatus status = state.status;
            if (status is FlashcardsStatusLoading) {
              Dialogs.showLoadingDialog();
            } else if (status is FlashcardsStatusFlashcardsAdded) {
              Dialogs.closeLoadingDialog(context);
              Navigator.pop(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie dodano nowe fiszki');
            } else if (status is FlashcardsStatusFlashcardUpdated) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is FlashcardsStatusFlashcardRemoved) {
              Dialogs.closeLoadingDialog(context);
              Navigator.pop(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie usunięto fiszkę');
            } else if (status is FlashcardsStatusFlashcardsSaved) {
              Dialogs.closeLoadingDialog(context);
              Navigator.of(context).pop();
              Dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is FlashcardsStatusError) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showErrorDialog(message: status.message);
            }
          },
        );
}
