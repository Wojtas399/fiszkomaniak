import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/components/session_preview_flashcards.dart';
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
        appBar: const AppBarWithCloseButton(label: 'Sesja'),
        body: BouncingScroll(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: const [
                  SessionPreviewFlashcards(),
                ],
              ),
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
      )..add(SessionPreviewEventInitialize(sessionId: sessionId)),
      child: child,
    );
  }
}
