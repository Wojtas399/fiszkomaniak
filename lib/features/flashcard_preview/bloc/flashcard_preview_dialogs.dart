import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class FlashcardPreviewDialogs {
  final Dialogs dialogs = Dialogs();

  Future<void> showEmptyFlashcardInfo() async {
    return await dialogs.showDialogWithMessage(
      title: 'Błąd',
      message:
          'Jedna ze stron fiszki nie została uzupełniona. Popraw ją aby móc zapisać zmiany.',
    );
  }

  Future<bool> askForDeleteConfirmation() async {
    return await dialogs.askForConfirmation(
          title: 'Usuwanie',
          text: 'Czy na pewno chcesz usunąć tę fiszkę?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }

  Future<bool> askForSaveConfirmation() async {
    return await dialogs.askForConfirmation(
          title: 'Zapisywanie',
          text: 'Czy na pewno chcesz zapisać zmiany wprowadzone w tej fiszce?',
          confirmButtonText: 'Zapisz',
        ) ==
        true;
  }
}
