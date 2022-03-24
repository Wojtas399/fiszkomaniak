import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/button.dart';
import '../../../components/textfields/textfield.dart';
import '../bloc/course_creator_state.dart';

class CourseCreatorContent extends StatelessWidget {
  final TextEditingController courseNameController = TextEditingController();

  CourseCreatorContent({Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCreatorBloc, CourseCreatorState>(
      builder: (BuildContext context, CourseCreatorState state) {
        if (!state.hasCourseNameBeenEdited) {
          courseNameController.text = state.courseName;
        }
        return OnTapFocusLoseArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                icon: MdiIcons.archive,
                label: 'Nazwa kursu',
                controller: courseNameController,
                onChanged: (String value) {
                  context
                      .read<CourseCreatorBloc>()
                      .add(CourseCreatorEventCourseNameChanged(
                        courseName: value,
                      ));
                },
              ),
              Button(
                label: state.buttonText,
                onPressed: state.isButtonDisabled
                    ? null
                    : () => context
                        .read<CourseCreatorBloc>()
                        .add(CourseCreatorEventSaveChanges()),
              ),
            ],
          ),
        );
      },
    );
  }
}
