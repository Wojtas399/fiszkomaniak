import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class FlashcardPreviewDialogs {
  final Dialogs dialogs = Dialogs();

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
