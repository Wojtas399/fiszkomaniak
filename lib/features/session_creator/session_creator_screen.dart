import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../config/navigation.dart';
import '../../domain/use_cases/courses/get_all_courses_use_case.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/courses/load_all_courses_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import '../../domain/use_cases/sessions/add_session_use_case.dart';
import '../../domain/use_cases/sessions/update_session_use_case.dart';
import '../../features/home/home.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../interfaces/notifications_interface.dart';
import '../../interfaces/settings_interface.dart';
import '../../interfaces/sessions_interface.dart';
import '../../models/bloc_status.dart';
import '../../utils/time_utils.dart';
import 'bloc/session_creator_bloc.dart';
import 'bloc/session_creator_mode.dart';
import 'components/session_creator_content.dart';

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
    return BlocProvider(
      create: (BuildContext context) => SessionCreatorBloc(
        loadAllCoursesUseCase: LoadAllCoursesUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        getAllCoursesUseCase: GetAllCoursesUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        getGroupsByCourseIdUseCase: GetGroupsByCourseIdUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        addSessionUseCase: AddSessionUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
          groupsInterface: context.read<GroupsInterface>(),
          notificationsInterface: context.read<NotificationsInterface>(),
          settingsInterface: context.read<SettingsInterface>(),
        ),
        updateSessionUseCase: UpdateSessionUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
          groupsInterface: context.read<GroupsInterface>(),
          notificationsInterface: context.read<NotificationsInterface>(),
          settingsInterface: context.read<SettingsInterface>(),
          timeUtils: TimeUtils(),
        ),
        timeUtils: TimeUtils(),
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
          final SessionCreatorInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(
    SessionCreatorInfo info,
    BuildContext context,
  ) {
    switch (info) {
      case SessionCreatorInfo.timeFromThePast:
        Dialogs.showDialogWithMessage(
          title: 'Niedozwolony czas',
          message:
              'Godzina rozpoczęcia lub godzina powiadomienia wraz z wybraną datą są z przeszłości.',
        );
        break;
      case SessionCreatorInfo.chosenStartTimeIsEarlierThanNotificationTime:
        Dialogs.showDialogWithMessage(
          title: 'Niedozwolona godzina',
          message:
              'Wybrana godzina rozpoczęcia sesji jest godziną wcześniejszą niż godzina powiadomienia.',
        );
        break;
      case SessionCreatorInfo.chosenNotificationTimeIsLaterThanStartTime:
        Dialogs.showDialogWithMessage(
          title: 'Niedozwolona godzina',
          message:
              'Wybrana godzina powiadomienia jest godziną późniejszą, niż godzina rozpoczęcia sesji.',
        );
        break;
      case SessionCreatorInfo.sessionHasBeenAdded:
        Navigation.backHome();
        context.read<HomePageController>().moveToPage(1);
        Dialogs.showSnackbarWithMessage('Pomyślnie dodano nową sesję');
        break;
      case SessionCreatorInfo.sessionHasBeenUpdated:
        Navigation.moveBack();
        Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano sesję');
        break;
    }
  }
}
