import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/get_all_sessions_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/load_all_sessions_use_case.dart';
import 'package:fiszkomaniak/features/sessions_list/bloc/sessions_list_bloc.dart';
import 'package:fiszkomaniak/features/sessions_list/components/sessions_list_content.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionsListScreen extends StatelessWidget {
  const SessionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SessionsListBlocProvider(
      child: _SessionsListBlocListener(
        child: SessionsListContent(),
      ),
    );
  }
}

class _SessionsListBlocProvider extends StatelessWidget {
  final Widget child;

  const _SessionsListBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SessionsListBloc(
        loadAllSessionsUseCase: LoadAllSessionsUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
        ),
        getAllSessionsUseCase: GetAllSessionsUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
        ),
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
      )..add(SessionsListEventInitialize()),
      child: child,
    );
  }
}

class _SessionsListBlocListener extends StatelessWidget {
  final Widget child;

  const _SessionsListBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionsListBloc, SessionsListState>(
      listener: (BuildContext context, SessionsListState state) {
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
