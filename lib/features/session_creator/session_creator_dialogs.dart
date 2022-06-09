import 'package:fiszkomaniak/components/dialogs/dialogs.dart';

class SessionCreatorDialogs {
  Future<void> showInfoAboutPastTime() async {
    await Dialogs.showDialogWithMessage(
      title: 'Niedozwolona godzina',
      message: 'Wybrana godzina z ustawionej daty sesji jest godziną przeszłą.',
    );
  }

  Future<void> showInfoAboutNotificationTimeLaterThanStartTime() async {
    await Dialogs.showDialogWithMessage(
      title: 'Niedozwolona godzina',
      message:
          'Wybrana godzina powiadomienia jest godziną późniejszą, niż godzina rozpoczęcia sesji.',
    );
  }

  Future<void> showInfoAboutStartTimeEarlierThanNotificationTime() async {
    await Dialogs.showDialogWithMessage(
      title: 'Niedozwolona godzina',
      message:
          'Wybrana godzina rozpoczęcia sesji jest godziną wcześniejszą niż godzina powiadomienia.',
    );
  }
}
