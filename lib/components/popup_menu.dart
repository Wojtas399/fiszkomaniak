import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PopupMenu extends StatelessWidget {
  final List<PopupMenuItemParams> items;
  final Function(int actionIndex) onPopupActionSelected;

  const PopupMenu({
    Key? key,
    required this.items,
    required this.onPopupActionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        child: PopupMenuButton(
          padding: const EdgeInsets.all(16),
          tooltip: '',
          icon: const Icon(MdiIcons.dotsVertical),
          itemBuilder: (_) => items
              .asMap()
              .entries
              .map(
                (item) => PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(item.value.icon, color: iconColor),
                      const SizedBox(width: 16),
                      Text(item.value.label),
                    ],
                  ),
                  onTap: () {
                    onPopupActionSelected(item.key);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class PopupMenuItemParams {
  final IconData icon;
  final String label;

  PopupMenuItemParams({required this.icon, required this.label});
}
