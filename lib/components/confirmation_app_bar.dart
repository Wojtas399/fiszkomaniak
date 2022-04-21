import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'custom_icon_button.dart';

class ConfirmationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onAccept;

  const ConfirmationAppBar({
    Key? key,
    this.onCancel,
    this.onAccept,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text('Zapisać zmiany?'),
      actions: [
        CustomIconButton(
          icon: MdiIcons.close,
          onPressed: onCancel,
        ),
        CustomIconButton(
          icon: MdiIcons.check,
          onPressed: onAccept,
        ),
      ],
    );
  }
}
