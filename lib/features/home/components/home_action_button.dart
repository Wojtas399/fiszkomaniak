import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../config/navigation.dart';
import '../../course_creator/bloc/course_creator_mode.dart';
import '../../group_creator/bloc/group_creator_mode.dart';
import '../../../features/session_creator/bloc/session_creator_mode.dart';

class HomeActionButton extends StatelessWidget {
  const HomeActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: MdiIcons.plus,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      spaceBetweenChildren: 8,
      buttonSize: const Size(74, 74),
      childrenButtonSize: const Size(64, 64),
      children: [
        SpeedDialChild(
          child: const Icon(MdiIcons.archive),
          label: 'Kurs',
          onTap: () {
            Navigation.navigateToCourseCreator(
              const CourseCreatorCreateMode(),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(MdiIcons.folder),
          label: 'Grupa',
          onTap: () {
            Navigation.navigateToGroupCreator(
              const GroupCreatorCreateMode(),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(MdiIcons.cards),
          label: 'Fiszki',
          onTap: () {
            Navigation.navigateToGroupSelection();
          },
        ),
        SpeedDialChild(
          child: const Icon(MdiIcons.calendarCheck),
          label: 'Sesja',
          onTap: () {
            Navigation.navigateToSessionCreator(
              const SessionCreatorCreateMode(),
            );
          },
        ),
      ],
    );
  }
}
