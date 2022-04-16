import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class GroupPreviewDialogs {
  final Dialogs dialogs = Dialogs();

  Future<bool> askForDeleteConfirmation() async {
    return await dialogs.askForConfirmation(
          title: 'Czy na pewno chcesz usunąć grupę?',
          text:
              'Usunięcie grupy spowoduje również usunięcie wszystkich fiszek należących do niej.',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
