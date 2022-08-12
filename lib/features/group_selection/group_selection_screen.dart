import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../providers/dialogs_provider.dart';
import '../../domain/use_cases/courses/get_all_courses_use_case.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/courses/load_all_courses_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import '../../interfaces/groups_interface.dart';
import '../../models/bloc_status.dart';
import '../../interfaces/courses_interface.dart';
import 'bloc/group_selection_bloc.dart';
import 'components/group_selection_content.dart';

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
    return BlocProvider(
      create: (BuildContext context) => GroupSelectionBloc(
        loadAllCoursesUseCase: LoadAllCoursesUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        getAllCoursesUseCase: GetAllCoursesUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        getGroupsByCourseIdUseCase: GetGroupsByCourseIdUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
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
          DialogsProvider.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
        }
      },
      child: child,
    );
  }
}
