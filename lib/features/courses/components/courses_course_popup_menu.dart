import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CoursesCoursePopupMenu extends StatelessWidget {
  const CoursesCoursePopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: PopupMenuButton(
        splashRadius: 24,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        icon: const Icon(MdiIcons.dotsVertical),
        padding: const EdgeInsets.all(0),
        itemBuilder: (_) => [
          PopupMenuItem(
            child: Row(
              children: const [
                Icon(MdiIcons.squareEditOutline),
                SizedBox(width: 16),
                Text('Edytuj'),
              ],
            ),
          ),
          PopupMenuItem(
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
    );
  }
}
