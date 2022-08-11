import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../config/navigation.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../domain/use_cases/sessions/get_session_use_case.dart';
import '../../domain/use_cases/sessions/delete_session_use_case.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../interfaces/notifications_interface.dart';
import '../../interfaces/sessions_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/session_preview_bloc.dart';
import 'bloc/session_preview_mode.dart';
import 'components/session_preview_content.dart';

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
        deleteSessionUseCase: DeleteSessionUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
          notificationsInterface: context.read<NotificationsInterface>(),
        ),
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
          final SessionPreviewInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(
    SessionPreviewInfo info,
    BuildContext context,
  ) {
    switch (info) {
      case SessionPreviewInfo.sessionHasBeenDeleted:
        Navigation.moveBack();
        Dialogs.showSnackbarWithMessage('Pomyślnie usunięto sesję');
        break;
    }
  }
}
