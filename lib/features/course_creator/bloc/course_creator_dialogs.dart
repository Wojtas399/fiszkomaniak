import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class CourseCreatorDialogs {
  Future<void> displayInfoAboutAlreadyTakenCourseName() async {
    await Dialogs.showDialogWithMessage(
      title: 'Zajęta nazwa',
      message:
          'W twojej bibliotece kursów już istnieje kurs o podanej nazwie. Zmień nazwę kursu aby móc go utworzyć.',
    );
  }
}
