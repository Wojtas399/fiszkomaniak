import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppBarWithCloseButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String label;

  const AppBarWithCloseButton({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(label),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(MdiIcons.close),
      ),
    );
  }
}
