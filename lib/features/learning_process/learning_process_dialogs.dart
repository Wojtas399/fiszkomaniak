import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class LearningProcessDialogs {
  final Dialogs _dialogs = Dialogs();

  Future<bool> askForSaveConfirmation() async {
    return await _dialogs.askForConfirmation(
          title: 'Zapisywanie',
          text: 'Czy chcesz zapisać zmiany przed zakończeniem sesji?',
          confirmButtonText: 'Zapisz',
        ) ==
        true;
  }
}
