import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class GroupPreviewDialogs {
  final Dialogs dialogs = Dialogs();

  Future<bool> askForDeleteConfirmation() async {
    return await dialogs.askForConfirmation(
          title: 'Czy na pewno chcesz usunąć grupę?',
          text:
              'Usunięcie grupy spowoduje również usunięcie wszystkich fiszek oraz sesji z nią powiązanych.',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
