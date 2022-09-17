import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/course_item/course_item.dart';
import '../../../components/course_item/course_item_popup_menu.dart';
import '../../../components/list_view_fade_animated_item.dart';
import '../../../config/navigation.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import '../../../interfaces/groups_interface.dart';
import '../../../providers/dialogs_provider.dart';
import '../../course_creator/bloc/course_creator_mode.dart';
import '../bloc/courses_library_bloc.dart';

class CoursesLibraryCoursesList extends StatelessWidget {
  const CoursesLibraryCoursesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Course> allCourses = context.select(
      (CoursesLibraryBloc bloc) => bloc.state.allCourses,
    );

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 16,
        right: 16,
        bottom: 100,
        left: 16,
      ),
      cacheExtent: 0,
      itemCount: allCourses.length,
      itemBuilder: (_, int index) {
        return ListViewFadeAnimatedItem(
          child: _CourseItem(
            course: allCourses[index],
          ),
        );
      },
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
