import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class FlashcardsEditorDialogs {
  final Dialogs dialogs = Dialogs();

  Future<bool?> askForSaveConfirmation() async {
    return await dialogs.askForConfirmation(
        title: 'Zapisywanie',
        text: 'Czy na pewno chcesz zapisać zmiany?',
        confirmButtonText: 'Zapisz');
  }

  Future<bool?> askForDeleteConfirmation() async {
    return await dialogs.askForConfirmation(
        title: 'Usuwanie',
        text:
            'Operacja ta jest nieodwracalna i spowoduje trwałe usunięcie fiszki. Czy na pewno chcesz usunąć fiszkę?',
        confirmButtonText: 'Usuń');
  }

  Future<void> displayInfoAboutIncorrectFlashcards() async {
    await dialogs.showDialogWithMessage(
      title: 'Błąd',
      message: 'Niektóre fiszki nie zostały poprawnie uzupełnione',
    );
  }

  Future<void> displayInfoAboutNoChanges() async {
    await dialogs.showDialogWithMessage(
      title: 'Operacja niedostępna',
      message: 'Wprowadź dowolne zmiany w fiszkach aby móc wykonać tę operację',
    );
  }

  Future<void> displayInfoAboutDuplicates() async {
    await dialogs.showDialogWithMessage(
      title: 'Powtarzające się fiszki',
      message:
          'Wygląda na to, że niektóre fiszki występują w tej grupie podwójnie! Zmień je aby móc zapisać zmiany',
    );
  }
}
