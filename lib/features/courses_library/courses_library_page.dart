import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_dialogs.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_event.dart';
import 'package:fiszkomaniak/features/courses_library/components/courses_library_course_item.dart';
import 'package:fiszkomaniak/features/courses_library/components/courses_library_course_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../models/course_model.dart';
import 'bloc/courses_library_state.dart';

class CoursesLibraryPage extends StatelessWidget {
  const CoursesLibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CoursesLibraryBlocProvider(
      child: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (BuildContext context, GroupsState groupsState) {
          return BlocBuilder<CoursesLibraryBloc, CoursesLibraryState>(
            builder: (
              BuildContext context,
              CoursesLibraryState coursesLibraryState,
            ) {
              if (coursesLibraryState.courses.isEmpty) {
                return const _NoCoursesInfo();
              }
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
                      children: coursesLibraryState.courses
                          .map(
                            (course) => _generateCourseItem(
                              context,
                              course,
                              groupsState.getGroupsByCourseId(course.id).length,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          );
        },
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

class _CoursesLibraryBlocProvider extends StatelessWidget {
  final Widget child;

  const _CoursesLibraryBlocProvider({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CoursesLibraryBloc(
        coursesBloc: context.read<CoursesBloc>(),
        groupsBloc: context.read<GroupsBloc>(),
        coursesLibraryDialogs: CoursesLibraryDialogs(),
        navigation: context.read<Navigation>(),
      )..add(CoursesLibraryEventInitialize()),
      child: child,
    );
  }
}

class _NoCoursesInfo extends StatelessWidget {
  const _NoCoursesInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: EmptyContentInfo(
          icon: MdiIcons.library,
          title: 'Brak utworzonych kursów',
          subtitle:
              'Naciśnij fioletowy przycisk znajdujący się na dolnym pasku aby dodać nowy kurs',
        ),
      ),
    );
  }
}
