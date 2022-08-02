import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/components/group_selection_content.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../interfaces/courses_interface.dart';

class GroupSelectionScreen extends StatelessWidget {
  const GroupSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GroupSelectionBlocProvider(
      child: _GroupSelectionBlocListener(
        child: GroupSelectionContent(),
      ),
    );
  }
}

class _GroupSelectionBlocProvider extends StatelessWidget {
  final Widget child;

  const _GroupSelectionBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    final CoursesInterface coursesInterface = context.read<CoursesInterface>();
    final GroupsInterface groupsInterface = context.read<GroupsInterface>();
    return BlocProvider(
      create: (BuildContext context) => GroupSelectionBloc(
        loadAllCoursesUseCase: LoadAllCoursesUseCase(
          coursesInterface: coursesInterface,
        ),
        getAllCoursesUseCase: GetAllCoursesUseCase(
          coursesInterface: coursesInterface,
        ),
        getCourseUseCase: GetCourseUseCase(coursesInterface: coursesInterface),
        getGroupsByCourseIdUseCase: GetGroupsByCourseIdUseCase(
          groupsInterface: groupsInterface,
        ),
        getGroupUseCase: GetGroupUseCase(groupsInterface: groupsInterface),
      )..add(GroupSelectionEventInitialize()),
      child: child,
    );
  }
}

class _GroupSelectionBlocListener extends StatelessWidget {
  final Widget child;

  const _GroupSelectionBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupSelectionBloc, GroupSelectionState>(
      listener: (BuildContext context, GroupSelectionState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
        }
      },
      child: child,
    );
  }
}
