import 'dart:io';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../components/dialogs/dialogs.dart';
import '../../components/dialogs/single_input_dialog/single_input_dialog.dart';

class ProfileDialogs {
  Future<bool> askForNewAvatarConfirmation(String imagePath) async {
    return await Dialogs.askForImageConfirmation(
          imageFile: File(imagePath),
        ) ==
        true;
  }

  Future<bool> askForAvatarDeletionConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: "Usuwanie",
          text: 'Czy na pewno chcesz usunąć obecne zdjęcie profilowe?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }

  Future<bool> askForSignOutConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: 'Wylogowywanie',
          text: 'Czy na pewno chcesz się wylogować z tego konta?',
          confirmButtonText: 'Wyloguj',
        ) ==
        true;
  }

  Future<String?> askForAccountDeletionConfirmationPassword() async {
    return await Dialogs.askForValue(
      appBarTitle: 'Usuwanie konta',
      textFieldIcon: MdiIcons.lock,
      textFieldType: TextFieldType.password,
      textFieldLabel: 'Hasło',
      title: 'Czy na pewno chcesz usunąć konto?',
      message:
          'Usunięcie konta spowoduje również nieodwracalne usunięcie wszystkich danych powiązanych z tym kontem. Jeśli chcesz wykonać tą operację, potwierdź ją hasłem.',
      submitButtonLabel: 'Usuń',
    );
  }
}
