import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../domain/use_cases/sessions/get_all_sessions_use_case.dart';
import '../../features/sessions_list/sessions_list_cubit.dart';
import '../../features/sessions_list/components/sessions_list_content.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../interfaces/sessions_interface.dart';

class SessionsListScreen extends StatelessWidget {
  const SessionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SessionsListBlocProvider(
      child: SessionsListContent(),
    );
  }
}

class _SessionsListBlocProvider extends StatelessWidget {
  final Widget child;

  const _SessionsListBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SessionsListCubit(
        getAllSessionsUseCase: GetAllSessionsUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
        ),
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
      )..initialize(),
      child: child,
    );
  }
}
