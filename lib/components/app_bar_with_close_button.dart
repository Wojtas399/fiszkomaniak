import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppBarWithCloseButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String label;
  final IconData closeIcon;
  final List<Widget>? actions;

  const AppBarWithCloseButton({
    Key? key,
    required this.label,
    this.closeIcon = MdiIcons.close,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(label),
      leading: CustomIconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: closeIcon,
      ),
      actions: actions,
    );
  }
}
