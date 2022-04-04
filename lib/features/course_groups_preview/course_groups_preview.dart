import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_event.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_state.dart';
import 'package:fiszkomaniak/features/course_groups_preview/components/course_groups_preview_app_bar.dart';
import 'package:fiszkomaniak/features/course_groups_preview/components/course_groups_preview_groups_list.dart';
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
      child: BlocBuilder<CourseGroupsPreviewBloc, CourseGroupsPreviewState>(
        builder: (BuildContext context, _) {
          return const Scaffold(
            appBar: CourseGroupsPreviewAppBar(),
            body: OnTapFocusLoseArea(
              child: SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CourseGroupsPreviewGroupsList(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
        coursesBloc: context.read<CoursesBloc>(),
        groupsBloc: context.read<GroupsBloc>(),
      )..add(CourseGroupsPreviewEventInitialize(courseId: courseId)),
      child: child,
    );
  }
}
