import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class GroupCreatorDialogs {
  final Dialogs _dialogs = Dialogs();

  Future<void> displayInfoAboutAlreadyTakenGroupNameInCourse() async {
    await _dialogs.showDialogWithMessage(
      title: 'Ta nazwa jest już zajęta',
      message:
          'W tym kursie już istnieje grupa o podanej nazwie. Zmień nazwę grupy aby móc ją dodać do tego kursu.',
    );
  }
}
