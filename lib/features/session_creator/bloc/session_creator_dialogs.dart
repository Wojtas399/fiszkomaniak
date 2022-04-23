import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class SessionCreatorDialogs {
  final Dialogs _dialogs = Dialogs();

  Future<void> displayInfoAboutNotAllowedTime() async {
    await _dialogs.showDialogWithMessage(
      title: 'Niedozwolona godzina',
      message:
          'Wybrana godzina z dzisiejszego dnia już minęła. Wybierz inną aby móc wprowadzić zmiany',
    );
  }

  Future<void> displayInfoAboutPastDate() async {
    await _dialogs.showDialogWithMessage(
      title: 'Uwaga!',
      message:
          'Obecna data sesji jest datą z przeszłości. Zmień ją aby mieć możliwość edycji godziny rozpoczęcia oraz przypomnienia',
    );
  }
}
