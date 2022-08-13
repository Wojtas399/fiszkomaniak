import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/avatar/avatar.dart';
import '../../../components/avatar/avatar_image_type.dart';
import '../../../providers/dialogs_provider.dart';
import '../../../components/modal_bottom_sheet.dart';
import '../bloc/profile_bloc.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({super.key});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = context.select(
      (ProfileBloc bloc) => bloc.state.avatarUrl,
    );
    return Avatar(
      imageType: avatarUrl != null && avatarUrl != ''
          ? AvatarImageTypeUrl(url: avatarUrl)
          : null,
      size: 250.0,
      onPressed: () => _avatarPressed(context, avatarUrl),
    );
  }

  Future<void> _avatarPressed(
    BuildContext context,
    String? avatarUrl,
  ) async {
    if (avatarUrl == null) {
      await _changeAvatar(context);
    } else {
      final int? actionNumber = await _askForAvatarAction();
      if (mounted) {
        if (actionNumber == 0) {
          await _changeAvatar(context);
        } else if (actionNumber == 1) {
          await _deleteAvatar(context);
        }
      }
    }
  }

  Future<void> _changeAvatar(BuildContext context) async {
    final int? imageSource = await _askForImageSource();
    if (imageSource == 0 || imageSource == 1) {
      final String? imagePath = await _askForNewImage(
        imageSource == 0 ? ImageSource.camera : ImageSource.gallery,
      );
      if (imagePath != null) {
        await _setNewImageAsAvatar(imagePath);
      }
    }
  }

  Future<int?> _askForAvatarAction() async {
    return await ModalBottomSheet.showWithOptions(
      title: 'Wybierz operację',
      options: [
        ModalBottomSheetOption(icon: MdiIcons.imageEdit, text: 'Edytuj'),
        ModalBottomSheetOption(icon: MdiIcons.delete, text: 'Usuń'),
      ],
    );
  }

  Future<void> _deleteAvatar(BuildContext context) async {
    final bool confirmation = await _askForAvatarDeletionConfirmation();
    if (confirmation && mounted) {
      context.read<ProfileBloc>().add(
            ProfileEventDeleteAvatar(),
          );
    }
  }

  Future<int?> _askForImageSource() async {
    return await ModalBottomSheet.showWithOptions(
      title: 'Wybierz źródło zdjęcia',
      options: [
        ModalBottomSheetOption(icon: MdiIcons.camera, text: 'Aparat'),
        ModalBottomSheetOption(icon: MdiIcons.image, text: 'Galeria'),
      ],
    );
  }

  Future<String?> _askForNewImage(ImageSource source) async {
    final XFile? file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      return file.path;
    }
    return null;
  }

  Future<void> _setNewImageAsAvatar(String imagePath) async {
    final bool newAvatarConfirmation = await _askForNewAvatarConfirmation(
      imagePath,
    );
    if (newAvatarConfirmation && mounted) {
      context.read<ProfileBloc>().add(
            ProfileEventChangeAvatar(imagePath: imagePath),
          );
    }
  }

  Future<bool> _askForNewAvatarConfirmation(String imagePath) async {
    return await DialogsProvider.askForImageConfirmation(
      imageFile: File(imagePath),
    );
  }

  Future<bool> _askForAvatarDeletionConfirmation() async {
    return await DialogsProvider.askForConfirmation(
      title: "Usuwanie",
      text: 'Czy na pewno chcesz usunąć obecne zdjęcie profilowe?',
      confirmButtonText: 'Usuń',
    );
  }
}
