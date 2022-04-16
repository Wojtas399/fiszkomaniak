import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class CoursesLibraryDialogs {
  final Dialogs dialogs = Dialogs();

  Future<bool> askForDeleteConfirmation() async {
    return await dialogs.askForConfirmation(
          title: 'Czy na pewno chcesz usunąć ten kurs?',
          text:
              'Usunięcie kursu spowoduje również usunięcie wszystkich grup oraz fiszek należących do tego kursu.',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
