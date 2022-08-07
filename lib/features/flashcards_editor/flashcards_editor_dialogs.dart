import '../../components/dialogs/dialogs.dart';

class FlashcardsEditorDialogs {
  Future<bool> askForSaveConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Zapisywanie',
          text: 'Czy na pewno chcesz zapisać zmiany?',
          confirmButtonText: 'Zapisz',
        ) ==
        true;
  }

  Future<bool> askForDeleteConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Usuwanie',
          text:
              'Operacja ta jest nieodwracalna i spowoduje trwałe usunięcie fiszki. Czy na pewno chcesz usunąć fiszkę?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
