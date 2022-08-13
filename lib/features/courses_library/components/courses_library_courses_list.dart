import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/course_item/course_item.dart';
import '../../../components/course_item/course_item_popup_menu.dart';
import '../../../config/navigation.dart';
import '../../../providers/dialogs_provider.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import '../../../interfaces/groups_interface.dart';
import '../../course_creator/bloc/course_creator_mode.dart';
import '../bloc/courses_library_bloc.dart';

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
    allCourses.sort(
      (Course course1, Course course2) => course1.name.compareTo(course2.name),
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

  Future<void> _onActionSelected(
    CoursePopupAction action,
    BuildContext context,
  ) async {
    switch (action) {
      case CoursePopupAction.edit:
        _onEditCourse();
        break;
      case CoursePopupAction.delete:
        await _onDeleteCourse(context);
        break;
    }
  }

  void _onEditCourse() {
    Navigation.navigateToCourseCreator(
      CourseCreatorEditMode(course: course),
    );
  }

  Future<void> _onDeleteCourse(BuildContext context) async {
    final CoursesLibraryBloc bloc = context.read<CoursesLibraryBloc>();
    final bool confirmation = await _askForCourseDeletionConfirmation();
    if (confirmation) {
      bloc.add(
        CoursesLibraryEventDeleteCourse(courseId: course.id),
      );
    }
  }

  Future<bool> _askForCourseDeletionConfirmation() async {
    return await DialogsProvider.askForConfirmation(
      title: 'Czy na pewno chcesz usunąć ten kurs?',
      text:
          'Usunięcie kursu spowoduje również usunięcie wszystkich grup, fiszek oraz sesji z nim powiązanych.',
      confirmButtonText: 'Usuń',
    );
  }
}
