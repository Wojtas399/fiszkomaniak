import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CourseItemPopupMenu extends StatelessWidget {
  final Function(CoursePopupAction action) onActionSelected;

  const CourseItemPopupMenu({
    super.key,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, right: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Material(
          color: Colors.transparent,
          child: PopupMenuButton(
            tooltip: '',
            icon: const Icon(MdiIcons.dotsVertical),
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: _onEditActionPressed,
                child: Row(
                  children: const [
                    Icon(MdiIcons.squareEditOutline),
                    SizedBox(width: 16),
                    Text('Edytuj'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: _onDeleteActionPressed,
                child: Row(
                  children: const [
                    Icon(MdiIcons.deleteOutline),
                    SizedBox(width: 16),
                    Text('Usuń'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEditActionPressed() {
    onActionSelected(CoursePopupAction.edit);
  }

  void _onDeleteActionPressed() {
    onActionSelected(CoursePopupAction.delete);
  }
}

enum CoursePopupAction {
  edit,
  delete,
}
