import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/on_tap_focus_lose_area.dart';
import '../../../components/buttons/button.dart';
import '../../../components/textfields/custom_textfield.dart';
import '../bloc/course_creator_bloc.dart';
import '../bloc/course_creator_mode.dart';

class CourseCreatorContent extends StatelessWidget {
  final TextEditingController courseNameController = TextEditingController();

  CourseCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCreatorBloc, CourseCreatorState>(
      builder: (BuildContext context, CourseCreatorState state) {
        CourseCreatorMode mode = state.mode;
        if (mode is CourseCreatorEditMode &&
            mode.course.name == state.courseName) {
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
                onChanged: (String value) => _onCourseNameChanged(
                  value,
                  context,
                ),
              ),
              Button(
                label: _getButtonText(state.mode),
                onPressed: state.isButtonDisabled
                    ? null
                    : () => _onSubmitButtonPressed(context),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getButtonText(CourseCreatorMode mode) {
    if (mode is CourseCreatorCreateMode) {
      return 'utwórz';
    } else if (mode is CourseCreatorEditMode) {
      return 'zapisz';
    }
    return '';
  }

  void _onCourseNameChanged(String value, BuildContext context) {
    context
        .read<CourseCreatorBloc>()
        .add(CourseCreatorEventCourseNameChanged(courseName: value));
  }

  void _onSubmitButtonPressed(BuildContext context) {
    context.read<CourseCreatorBloc>().add(CourseCreatorEventSaveChanges());
  }
}
