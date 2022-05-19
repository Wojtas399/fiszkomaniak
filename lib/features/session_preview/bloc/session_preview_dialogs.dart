import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class SessionPreviewDialogs {
  Future<bool> askForDeleteConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Usuwanie sesji',
          text: 'Czy na pewno chcesz usunąć tą sesję?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
