import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/get_session_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/remove_session_use_case.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/components/session_preview_content.dart';
import 'package:fiszkomaniak/features/session_preview/session_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionPreviewScreen extends StatelessWidget {
  final SessionPreviewMode mode;

  const SessionPreviewScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return _SessionPreviewBlocProvider(
      mode: mode,
      child: const _SessionPreviewBlocListener(
        child: SessionPreviewContent(),
      ),
    );
  }
}

class _SessionPreviewBlocProvider extends StatelessWidget {
  final SessionPreviewMode mode;
  final Widget child;

  const _SessionPreviewBlocProvider({
    required this.mode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SessionPreviewBloc(
        getSessionUseCase: GetSessionUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
        ),
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        removeSessionUseCase: RemoveSessionUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
          notificationsInterface: context.read<NotificationsInterface>(),
        ),
        sessionPreviewDialogs: SessionPreviewDialogs(),
      )..add(SessionPreviewEventInitialize(mode: mode)),
      child: child,
    );
  }
}

class _SessionPreviewBlocListener extends StatelessWidget {
  final Widget child;

  const _SessionPreviewBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionPreviewBloc, SessionPreviewState>(
      listener: (BuildContext context, SessionPreviewState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final SessionPreviewInfoType? infoType = blocStatus.info;
          if (infoType != null) {
            _manageInfoType(infoType, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfoType(
    SessionPreviewInfoType infoType,
    BuildContext context,
  ) {
    switch (infoType) {
      case SessionPreviewInfoType.sessionHasBeenDeleted:
        context.read<Navigation>().moveBack();
        Dialogs.showSnackbarWithMessage('Pomyślnie usunięto sesję');
        break;
    }
  }
}
