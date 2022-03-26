import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CoursesCoursePopupMenu extends StatelessWidget {
  final Function(CoursePopupAction action) onActionSelected;

  const CoursesCoursePopupMenu({
    Key? key,
    required this.onActionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, right: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Material(
          color: Colors.transparent,
          child: PopupMenuButton(
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
                  onActionSelected(CoursePopupAction.edit);
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
                  onActionSelected(CoursePopupAction.remove);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CoursePopupAction {
  edit,
  remove,
}
