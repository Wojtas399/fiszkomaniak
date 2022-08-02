import '../../../components/dialogs/dialogs.dart';

class LearningProcessDialogs {
  Future<bool> askForSaveConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Koniec sesji',
          text: 'Czy chcesz zapisać zmiany przed zakończeniem sesji?',
          confirmButtonText: 'Zapisz',
        ) ==
        true;
  }

  Future<bool> askForContinuing() async {
    return await Dialogs.askForConfirmation(
          title: 'Koniec czasu',
          text:
              'Upłynął czas trwania sesji. Chcesz kontynuować bez minutnika czy zapisać postępy i wyjść?',
          confirmButtonText: 'Kontynuuj',
          cancelButtonText: 'Zapisz i wyjdź',
        ) ==
        true;
  }
}
