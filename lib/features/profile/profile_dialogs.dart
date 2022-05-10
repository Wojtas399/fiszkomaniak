import 'dart:io';
import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/components/modal_bottom_sheet.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileDialogs {
  final Dialogs _dialogs = Dialogs();

  Future<AvatarActions?> askForAvatarAction() async {
    final int? selectedOption = await ModalBottomSheet.showWithOptions(
      title: 'Wybierz operację',
      options: [
        ModalBottomSheetOption(icon: MdiIcons.imageEdit, text: 'Edytuj'),
        ModalBottomSheetOption(icon: MdiIcons.delete, text: 'Usuń'),
      ],
    );
    switch (selectedOption) {
      case 0:
        return AvatarActions.edit;
      case 1:
        return AvatarActions.delete;
      default:
        return null;
    }
  }

  Future<ImageSource?> askForImageSource() async {
    final int? selectedOption = await ModalBottomSheet.showWithOptions(
      title: 'Wybierz źródło zdjęcia',
      options: [
        ModalBottomSheetOption(icon: MdiIcons.camera, text: 'Aparat'),
        ModalBottomSheetOption(icon: MdiIcons.image, text: 'Galeria'),
      ],
    );
    switch (selectedOption) {
      case 0:
        return ImageSource.camera;
      case 1:
        return ImageSource.gallery;
      default:
        return null;
    }
  }

  Future<bool> askForImageConfirmation(String filePath) async {
    return await _dialogs.askForImageConfirmation(
          imageFile: File(filePath),
        ) ==
        true;
  }

  Future<bool> askForDeleteAvatarConfirmation() async {
    return await _dialogs.askForConfirmation(
          title: "Usuwanie",
          text: 'Czy na pewno chcesz usunąć obecne zdjęcie profilowe?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }
}
