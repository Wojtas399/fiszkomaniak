import 'dart:io';
import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/components/modal_bottom_sheet.dart';
import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/features/profile/components/password_editor/bloc/password_editor_bloc.dart';
import 'package:fiszkomaniak/features/profile/components/password_editor/password_editor.dart';
import 'package:fiszkomaniak/features/profile/components/username_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileDialogs {
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
    return await Dialogs.askForImageConfirmation(
          imageFile: File(filePath),
        ) ==
        true;
  }

  Future<bool> askForDeleteAvatarConfirmation() async {
    return await Dialogs.askForConfirmation(
          title: "Usuwanie",
          text: 'Czy na pewno chcesz usunąć obecne zdjęcie profilowe?',
          confirmButtonText: 'Usuń',
        ) ==
        true;
  }

  Future<String?> askForNewUsername(String currentUsername) async {
    final BuildContext? context = HomeRouter.navigatorKey.currentContext;
    if (context != null) {
      return await Navigator.of(context).push(SlideUpRouteAnimation(
        page: UsernameEditor(currentUsername: currentUsername),
      ));
    }
    return null;
  }

  Future<PasswordEditorReturns?> askForNewPassword() async {
    final BuildContext? context = HomeRouter.navigatorKey.currentContext;
    if (context != null) {
      return await Navigator.of(context).push(
        SlideUpRouteAnimation(page: const PasswordEditor()),
      );
    }
    return null;
  }
}
