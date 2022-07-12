import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/add_session_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/update_session_use_case.dart';
import 'package:fiszkomaniak/features/home/home.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_content.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCreatorScreen extends StatelessWidget {
  final SessionCreatorMode mode;

  const SessionCreatorScreen({
    super.key,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return _SessionCreatorBlocProvider(
      mode: mode,
      child: const _SessionCreatorBlocListener(
        child: SessionCreatorContent(),
      ),
    );
  }
}

class _SessionCreatorBlocProvider extends StatelessWidget {
  final SessionCreatorMode mode;
  final Widget child;

  const _SessionCreatorBlocProvider({
    required this.child,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final CoursesInterface coursesInterface = context.read<CoursesInterface>();
    final GroupsInterface groupsInterface = context.read<GroupsInterface>();
    final SessionsInterface sessionsInterface =
        context.read<SessionsInterface>();
    return BlocProvider(
      create: (BuildContext context) => SessionCreatorBloc(
        loadAllCoursesUseCase: LoadAllCoursesUseCase(
          coursesInterface: coursesInterface,
        ),
        getAllCoursesUseCase: GetAllCoursesUseCase(
          coursesInterface: coursesInterface,
        ),
        getCourseUseCase: GetCourseUseCase(coursesInterface: coursesInterface),
        getGroupUseCase: GetGroupUseCase(groupsInterface: groupsInterface),
        getGroupsByCourseIdUseCase: GetGroupsByCourseIdUseCase(
          groupsInterface: groupsInterface,
        ),
        addSessionUseCase: AddSessionUseCase(
          sessionsInterface: sessionsInterface,
        ),
        updateSessionUseCase: UpdateSessionUseCase(
          sessionsInterface: sessionsInterface,
        ),
      )..add(SessionCreatorEventInitialize(mode: mode)),
      child: child,
    );
  }
}

class _SessionCreatorBlocListener extends StatelessWidget {
  final Widget child;

  const _SessionCreatorBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCreatorBloc, SessionCreatorState>(
      listener: (BuildContext context, SessionCreatorState state) async {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final SessionCreatorInfoType? infoType = blocStatus.info;
          if (infoType != null) {
            _manageInfoType(infoType, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfoType(
    SessionCreatorInfoType infoType,
    BuildContext context,
  ) {
    switch (infoType) {
      case SessionCreatorInfoType.timeFromThePast:
        Dialogs.showDialogWithMessage(
          title: 'Niedozwolony czas',
          message:
              'Godzina rozpoczęcia lub godzina powiadomienia wraz z wybraną datą są z przeszłości.',
        );
        break;
      case SessionCreatorInfoType.chosenStartTimeIsEarlierThanNotificationTime:
        Dialogs.showDialogWithMessage(
          title: 'Niedozwolona godzina',
          message:
              'Wybrana godzina rozpoczęcia sesji jest godziną wcześniejszą niż godzina powiadomienia.',
        );
        break;
      case SessionCreatorInfoType.chosenNotificationTimeIsLaterThanStartTime:
        Dialogs.showDialogWithMessage(
          title: 'Niedozwolona godzina',
          message:
              'Wybrana godzina powiadomienia jest godziną późniejszą, niż godzina rozpoczęcia sesji.',
        );
        break;
      case SessionCreatorInfoType.sessionHasBeenAdded:
        context.read<Navigation>().backHome();
        context.read<HomePageController>().moveToPage(1);
        Dialogs.showSnackbarWithMessage('Pomyślnie dodano nową sesję');
        break;
      case SessionCreatorInfoType.sessionHasBeenUpdated:
        context.read<Navigation>().moveBack();
        Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano sesję');
        break;
    }
  }
}
