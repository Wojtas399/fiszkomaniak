import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class GroupCreatorDialogs {
  Future<void> displayInfoAboutAlreadyTakenGroupNameInCourse() async {
    await Dialogs.showDialogWithMessage(
      title: 'Ta nazwa jest już zajęta',
      message:
          'W tym kursie już istnieje grupa o podanej nazwie. Zmień nazwę grupy aby móc ją dodać do tego kursu.',
    );
  }
}
