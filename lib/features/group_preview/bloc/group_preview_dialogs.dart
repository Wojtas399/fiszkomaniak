import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class GroupPreviewDialogs {
  Future<bool> askForDeleteConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Czy na pewno chcesz usunąć grupę?',
          text:
              'Usunięcie grupy spowoduje również usunięcie wszystkich fiszek oraz sesji z nią powiązanych.',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
