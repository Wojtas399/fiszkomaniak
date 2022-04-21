import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class SessionPreviewDialogs {
  final Dialogs _dialogs = Dialogs();

  Future<void> showMessageAboutWrongTimeFromToday() async {
    await _dialogs.showDialogWithMessage(
      title: 'Błędna godzina',
      message:
          'Wybrana godzina rozpoczęcia już minęła. Zmień ją, aby móc zapisać zmiany',
    );
  }

  Future<bool> askForDeleteConfirmation() async {
    return await _dialogs.askForConfirmation(
          title: 'Usuwanie sesje',
          text: 'Czy na pewno chcesz usunąć tą sesję?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
