import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class CourseCreatorDialogs {
  final Dialogs _dialogs = Dialogs();

  Future<void> displayInfoAboutAlreadyTakenCourseName() async {
    await _dialogs.showDialogWithMessage(
      title: 'Zajęta nazwa',
      message:
          'W twojej bibliotece kursów już istnieje kurs o podanej nazwie. Zmień nazwę kursu aby móc go utworzyć.',
    );
  }
}
