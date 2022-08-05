import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import '../../features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import '../../features/course_groups_preview/components/course_groups_preview_app_bar.dart';
import '../../features/course_groups_preview/components/course_groups_preview_body.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';

class CourseGroupsPreviewScreen extends StatelessWidget {
  final String courseId;

  const CourseGroupsPreviewScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return _CourseGroupsPreviewBlocProvider(
      courseId: courseId,
      child: const Scaffold(
        appBar: CourseGroupsPreviewAppBar(),
        body: CourseGroupsPreviewBody(),
      ),
    );
  }
}

class _CourseGroupsPreviewBlocProvider extends StatelessWidget {
  final String courseId;
  final Widget child;

  const _CourseGroupsPreviewBlocProvider({
    required this.courseId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CourseGroupsPreviewBloc(
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        getGroupsByCourseIdUseCase: GetGroupsByCourseIdUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
      )..add(CourseGroupsPreviewEventInitialize(courseId: courseId)),
      child: child,
    );
  }
}
