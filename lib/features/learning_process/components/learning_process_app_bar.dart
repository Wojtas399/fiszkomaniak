import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LearningProcessAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const LearningProcessAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CustomIconButton(
        icon: MdiIcons.arrowLeft,
        onPressed: () {
          Navigator.pop(context);
          //TODO
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _FlashcardsState(),
          SizedBox(width: 16),
          _Timer(),
        ],
      ),
      actions: [
        CustomIconButton(
          icon: MdiIcons.delete,
          onPressed: () {
            //TODO
          },
        ),
      ],
    );
  }
}

class _FlashcardsState extends StatelessWidget {
  const _FlashcardsState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('250/500');
  }
}

class _Timer extends StatelessWidget {
  const _Timer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(MdiIcons.clockOutline),
        SizedBox(width: 4),
        Text('13:21'),
      ],
    );
  }
}
