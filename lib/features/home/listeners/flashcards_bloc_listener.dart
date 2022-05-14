import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/flashcards/flashcards_status.dart';

class FlashcardsBlocListener
    extends BlocListener<FlashcardsBloc, FlashcardsState> {
  FlashcardsBlocListener({Key? key})
      : super(
          key: key,
          listener: (BuildContext context, FlashcardsState state) {
            final FlashcardsStatus status = state.status;
            void closeLoadingDialog() {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (status is FlashcardsStatusLoading) {
              Dialogs.showLoadingDialog();
            } else if (status is FlashcardsStatusFlashcardsAdded) {
              closeLoadingDialog();
              Navigator.pop(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie dodano nowe fiszki');
            } else if (status is FlashcardsStatusFlashcardUpdated) {
              closeLoadingDialog();
              Dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is FlashcardsStatusFlashcardRemoved) {
              closeLoadingDialog();
              Navigator.pop(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie usunięto fiszkę');
            } else if (status is FlashcardsStatusFlashcardsSaved) {
              closeLoadingDialog();
              Navigator.of(context).pop();
              Dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is FlashcardsStatusError) {
              closeLoadingDialog();
              Dialogs.showErrorDialog(message: status.message);
            }
          },
        );
}
