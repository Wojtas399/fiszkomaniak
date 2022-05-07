import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class LearningProcessDialogs {
  final Dialogs _dialogs = Dialogs();

  Future<bool> askForSaveConfirmation() async {
    return await _dialogs.askForConfirmation(
          title: 'Koniec sesji',
          text: 'Czy chcesz zapisać zmiany przed zakończeniem sesji?',
          confirmButtonText: 'Zapisz',
        ) ==
        true;
  }

  Future<bool> askForContinuing() async {
    return await _dialogs.askForConfirmation(
          title: 'Koniec czasu',
          text:
              'Upłynął czas trwania sesji. Chcesz kontynuować bez minutnika czy zapisać postępy i wyjść?',
          confirmButtonText: 'Kontynuuj',
          cancelButtonText: 'Zapisz i wyjdź',
        ) ==
        true;
  }
}
