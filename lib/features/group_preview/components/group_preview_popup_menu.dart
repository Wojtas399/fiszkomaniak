import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupPreviewPopupMenu extends StatelessWidget {
  final Function(GroupPopupAction action) onPopupActionSelected;

  const GroupPreviewPopupMenu({
    Key? key,
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
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(MdiIcons.squareEditOutline, color: iconColor),
                  const SizedBox(width: 16),
                  const Text('Edytuj'),
                ],
              ),
              onTap: () {
                onPopupActionSelected(GroupPopupAction.edit);
              },
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(MdiIcons.plus, color: iconColor),
                  const SizedBox(width: 16),
                  const Text('Dodaj fiszki'),
                ],
              ),
              onTap: () {
                onPopupActionSelected(GroupPopupAction.addFlashcards);
              },
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(MdiIcons.deleteOutline, color: iconColor),
                  const SizedBox(width: 16),
                  const Text('Usuń'),
                ],
              ),
              onTap: () {
                onPopupActionSelected(GroupPopupAction.remove);
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum GroupPopupAction {
  edit,
  addFlashcards,
  remove,
}
