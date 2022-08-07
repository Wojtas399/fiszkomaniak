import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/course_item.dart';
import '../../../config/navigation.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import '../../../features/course_creator/course_creator_mode.dart';
import '../../../interfaces/groups_interface.dart';
import '../bloc/courses_library_bloc.dart';
import 'courses_library_course_popup_menu.dart';

class CoursesLibraryCoursesList extends StatelessWidget {
  const CoursesLibraryCoursesList({super.key});

  @override
  Widget build(BuildContext context) {
    return const BouncingScroll(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            right: 16,
            bottom: 32,
            left: 16,
          ),
          child: _CoursesList(),
        ),
      ),
    );
  }
}

class _CoursesList extends StatelessWidget {
  const _CoursesList();

  @override
  Widget build(BuildContext context) {
    final List<Course> allCourses = context.select(
      (CoursesLibraryBloc bloc) => bloc.state.allCourses,
    );
    return Column(
      children: allCourses
          .map((Course course) => _CourseItem(course: course))
          .toList(),
    );
  }
}

class _CourseItem extends StatelessWidget {
  final Course course;

  const _CourseItem({required this.course});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _getAmountOfGroups(context),
      builder: (_, AsyncSnapshot<int> snapshot) {
        return CourseItem(
          courseName: course.name,
          amountOfGroups: snapshot.data ?? 0,
          onPressed: () => _onPressed(context),
          onActionSelected: (CoursePopupAction action) => _onActionSelected(
            action,
            context,
          ),
        );
      },
    );
  }

  Stream<int> _getAmountOfGroups(BuildContext context) {
    return GetGroupsByCourseIdUseCase(
      groupsInterface: context.read<GroupsInterface>(),
    )
        .execute(courseId: course.id)
        .map((List<Group> groupsFromCourse) => groupsFromCourse.length);
  }

  void _onPressed(BuildContext context) {
    Navigation.navigateToCourseGroupsPreview(course.id);
  }

  void _onActionSelected(
    CoursePopupAction action,
    BuildContext context,
  ) {
    switch (action) {
      case CoursePopupAction.edit:
        Navigation.navigateToCourseCreator(
          CourseCreatorEditMode(course: course),
        );
        break;
      case CoursePopupAction.remove:
        context.read<CoursesLibraryBloc>().add(
              CoursesLibraryEventDeleteCourse(courseId: course.id),
            );
        break;
    }
  }
}
