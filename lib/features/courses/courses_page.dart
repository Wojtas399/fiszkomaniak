import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:fiszkomaniak/features/courses/components/courses_course_item.dart';
import 'package:fiszkomaniak/features/courses/components/courses_course_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/course_model.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (BuildContext context, CoursesState state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: state.allCourses
                  .map((course) => CoursesCourseItem(
                        title: course.name,
                        amountOfGroups: 4,
                        onActionSelected: (CoursePopupAction action) {
                          _manageCourseAction(context, action, course);
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _manageCourseAction(
    BuildContext context,
    CoursePopupAction action,
    Course course,
  ) {
    switch (action) {
      case CoursePopupAction.edit:
        Navigation.navigateToCourseCreator(
          CourseCreatorEditMode(
            courseId: course.id,
            courseName: course.name,
          ),
        );
        break;
      case CoursePopupAction.remove:
        context
            .read<CoursesBloc>()
            .add(CoursesEventRemoveCourse(courseId: course.id));
        break;
    }
  }
}
