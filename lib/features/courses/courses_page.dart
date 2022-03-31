import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
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
      builder: (_, CoursesState coursesState) {
        return BlocBuilder<GroupsBloc, GroupsState>(
          builder: (BuildContext context, GroupsState groupsState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: coursesState.allCourses
                      .map(
                        (course) => _generateCourseItem(
                          context,
                          course,
                          groupsState,
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _generateCourseItem(
    BuildContext context,
    Course course,
    GroupsState groupsState,
  ) {
    return CoursesCourseItem(
      title: course.name,
      amountOfGroups: groupsState.getGroupsByCourseId(course.id).length,
      onActionSelected: (CoursePopupAction action) {
        _manageCourseAction(context, action, course);
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
