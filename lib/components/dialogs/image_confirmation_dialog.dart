import 'dart:io';
import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../avatar/avatar.dart';
import '../avatar/avatar_image_type.dart';
import '../buttons/small_button.dart';

class ImageConfirmationDialog extends StatelessWidget {
  final File imageFile;

  const ImageConfirmationDialog({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nowe zdjęcie profilowe'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _Header(),
                Avatar(
                  imageType: AvatarImageTypeFile(file: imageFile),
                  size: MediaQuery.of(context).size.width - 48,
                ),
                const _Buttons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Czy chcesz ustawić to zdjęcie jako zdjęcie profilowe?',
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SmallButton(
          label: 'Anuluj',
          color: AppColors.red,
          onPressed: () => _cancel(context),
        ),
        const SizedBox(width: 24.0),
        SmallButton(
          label: 'Ustaw',
          color: AppColors.green,
          onPressed: () => _confirm(context),
        ),
      ],
    );
  }

  void _cancel(BuildContext context) {
    Navigator.of(context).pop(false);
  }

  void _confirm(BuildContext context) {
    Navigator.of(context).pop(true);
  }
}
