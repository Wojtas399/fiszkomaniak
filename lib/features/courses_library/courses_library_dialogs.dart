import '../../components/dialogs/dialogs.dart';

class CoursesLibraryDialogs {
  Future<bool> askForDeleteConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Czy na pewno chcesz usunąć ten kurs?',
          text:
              'Usunięcie kursu spowoduje również usunięcie wszystkich grup, fiszek oraz sesji z nim powiązanych.',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
