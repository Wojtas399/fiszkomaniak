import '../../components/dialogs/dialogs.dart';

class FlashcardPreviewDialogs {
  Future<bool> askForDeleteConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Usuwanie',
          text: 'Czy na pewno chcesz usunąć tę fiszkę?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }

  Future<bool> askForSaveConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Zapisywanie',
          text: 'Czy na pewno chcesz zapisać zmiany wprowadzone w tej fiszce?',
          confirmButtonText: 'Zapisz',
        ) ==
        true;
  }
}
