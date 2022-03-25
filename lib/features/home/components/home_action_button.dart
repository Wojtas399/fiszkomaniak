import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeActionButton extends StatelessWidget {
  const HomeActionButton({Key? key}) : super(key: key);

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
              context,
              const CourseCreatorCreateMode(),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(MdiIcons.folder),
          label: 'Grupa',
        ),
        SpeedDialChild(
          child: const Icon(MdiIcons.paletteSwatch),
          label: 'Fiszki',
        ),
      ],
    );
  }
}