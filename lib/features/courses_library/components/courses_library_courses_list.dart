import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../config/navigation.dart';
import '../../../domain/entities/course.dart';
import '../bloc/courses_library_bloc.dart';
import 'courses_library_course_item.dart';
import 'courses_library_course_popup_menu.dart';

class CoursesLibraryCoursesList extends StatelessWidget {
  final List<Course> courses;

  const CoursesLibraryCoursesList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return BouncingScroll(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            right: 16,
            bottom: 32,
            left: 16,
          ),
          child: Column(
            children: courses
                .map((course) => _generateCourseItem(context, course, 5))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _generateCourseItem(
    BuildContext context,
    Course course,
    int amountOfGroups,
  ) {
    return CoursesLibraryCourseItem(
      title: course.name,
      amountOfGroups: amountOfGroups,
      onTap: () {
        context.read<Navigation>().navigateToCourseGroupsPreview(course.id);
      },
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
        context
            .read<CoursesLibraryBloc>()
            .add(CoursesLibraryEventEditCourse(course: course));
        break;
      case CoursePopupAction.remove:
        context
            .read<CoursesLibraryBloc>()
            .add(CoursesLibraryEventRemoveCourse(courseId: course.id));
        break;
    }
  }
}
