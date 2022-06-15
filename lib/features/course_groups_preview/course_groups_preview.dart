import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/components/course_groups_preview_app_bar.dart';
import 'package:fiszkomaniak/features/course_groups_preview/components/course_groups_preview_content.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseGroupsPreview extends StatelessWidget {
  final String courseId;

  const CourseGroupsPreview({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CourseGroupsPreviewBlocProvider(
      courseId: courseId,
      child: const Scaffold(
        appBar: CourseGroupsPreviewAppBar(),
        body: CourseGroupsPreviewContent(),
      ),
    );
  }
}

class _CourseGroupsPreviewBlocProvider extends StatelessWidget {
  final String courseId;
  final Widget child;

  const _CourseGroupsPreviewBlocProvider({
    Key? key,
    required this.courseId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CourseGroupsPreviewBloc(
        coursesInterface: context.read<CoursesInterface>(),
        groupsBloc: context.read<GroupsBloc>(),
      )..add(CourseGroupsPreviewEventInitialize(courseId: courseId)),
      child: child,
    );
  }
}
