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
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton(
          padding: const EdgeInsets.all(16),
          tooltip: '',
          icon: const Icon(MdiIcons.dotsVertical),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(MdiIcons.squareEditOutline),
                  SizedBox(width: 16),
                  Text('Edytuj'),
                ],
              ),
              onTap: () {
                onPopupActionSelected(GroupPopupAction.edit);
              },
            ),
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(MdiIcons.plus),
                  SizedBox(width: 16),
                  Text('Dodaj fiszki'),
                ],
              ),
              onTap: () {
                onPopupActionSelected(GroupPopupAction.addFlashcards);
              },
            ),
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(MdiIcons.deleteOutline),
                  SizedBox(width: 16),
                  Text('Usuń'),
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
