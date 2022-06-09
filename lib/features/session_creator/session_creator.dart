import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_status.dart';
import 'package:fiszkomaniak/features/session_creator/session_creator_dialogs.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_app_bar.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_button.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_date_and_time.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_flashcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCreator extends StatelessWidget {
  final SessionCreatorMode mode;

  const SessionCreator({
    Key? key,
    required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SessionCreatorBlocProvider(
      mode: mode,
      child: _SessionCreatorBlocListener(
        child: Scaffold(
          appBar: const SessionCreatorAppBar(),
          body: BouncingScroll(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: const [
                    SessionCreatorFlashcards(),
                    SessionCreatorDateAndTime(),
                    SizedBox(height: 16),
                    SessionCreatorButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
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
        coursesBloc: context.read<CoursesBloc>(),
        groupsBloc: context.read<GroupsBloc>(),
        sessionsBloc: context.read<SessionsBloc>(),
      )..add(SessionCreatorEventInitialize(mode: mode)),
      child: child,
    );
  }
}

class _SessionCreatorBlocListener extends StatelessWidget {
  final SessionCreatorDialogs _dialogs = SessionCreatorDialogs();
  final Widget child;

  _SessionCreatorBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCreatorBloc, SessionCreatorState>(
      listener: (_, SessionCreatorState state) async {
        final SessionCreatorStatus status = state.status;
        if (status is SessionCreatorStatusTimeFromThePast) {
          await _dialogs.showInfoAboutPastTime();
        } else if (status
            is SessionCreatorStatusStartTimeEarlierThanNotificationTime) {
          await _dialogs.showInfoAboutStartTimeEarlierThanNotificationTime();
        } else if (status
            is SessionCreatorStatusNotificationTimeLaterThanStartTime) {
          await _dialogs.showInfoAboutNotificationTimeLaterThanStartTime();
        }
      },
      child: child,
    );
  }
}
