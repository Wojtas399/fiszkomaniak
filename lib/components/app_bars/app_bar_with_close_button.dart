import 'package:flutter/material.dart';
import '../../providers/ui_elements_provider.dart';
import '../custom_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final IconData? leadingIcon;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.label,
    this.leadingIcon,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(label),
      leading: _LeadingIcon(),
      actions: actions,
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final UIElementsProvider _uiElementsProvider = UIElementsProvider();

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: _uiElementsProvider.getAppBarBackIcon(),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
