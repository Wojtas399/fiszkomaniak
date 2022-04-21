import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/components/session_preview_app_bar.dart';
import 'package:fiszkomaniak/features/session_preview/components/session_preview_button.dart';
import 'package:fiszkomaniak/features/session_preview/components/session_preview_flashcards.dart';
import 'package:fiszkomaniak/features/session_preview/components/session_preview_time.dart';
import 'package:fiszkomaniak/features/session_preview/components/session_preview_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionPreview extends StatelessWidget {
  final String sessionId;

  const SessionPreview({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SessionPreviewBlocProvider(
      sessionId: sessionId,
      child: Scaffold(
        appBar: const SessionPreviewAppBar(),
        body: SafeArea(
          child: SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                BouncingScroll(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 24.0,
                      bottom: 96.0,
                    ),
                    child: Column(
                      children: const [
                        SessionPreviewTitle(),
                        SizedBox(height: 8.0),
                        SessionPreviewTime(),
                        SessionPreviewFlashcards(),
                      ],
                    ),
                  ),
                ),
                const SessionPreviewButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionPreviewBlocProvider extends StatelessWidget {
  final String sessionId;
  final Widget child;

  const _SessionPreviewBlocProvider({
    Key? key,
    required this.sessionId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SessionPreviewBloc(
        coursesBloc: context.read<CoursesBloc>(),
        groupsBloc: context.read<GroupsBloc>(),
        sessionsBloc: context.read<SessionsBloc>(),
        sessionPreviewDialogs: SessionPreviewDialogs(),
      )..add(SessionPreviewEventInitialize(sessionId: sessionId)),
      child: child,
    );
  }
}
