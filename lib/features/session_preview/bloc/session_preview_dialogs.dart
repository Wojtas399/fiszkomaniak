import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class SessionPreviewDialogs {
  final Dialogs _dialogs = Dialogs();

  Future<bool> askForDeleteConfirmation() async {
    return await _dialogs.askForConfirmation(
          title: 'Usuwanie sesji',
          text: 'Czy na pewno chcesz usunąć tą sesję?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
