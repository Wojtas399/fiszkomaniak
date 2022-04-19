import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_button.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_date_and_time.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_flashcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCreator extends StatelessWidget {
  const SessionCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SessionCreatorBlocProvider(
      child: Scaffold(
        appBar: const AppBarWithCloseButton(label: 'Nowa sesja'),
        body: BouncingScroll(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: const [
                  SessionCreatorFlashcards(),
                  SessionCreatorDateAndTime(),
                  SizedBox(height: 32),
                  SessionCreatorButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionCreatorBlocProvider extends StatelessWidget {
  final Widget child;

  const _SessionCreatorBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SessionCreatorBloc(
        coursesBloc: context.read<CoursesBloc>(),
        groupsBloc: context.read<GroupsBloc>(),
        flashcardsBloc: context.read<FlashcardsBloc>(),
        sessionsBloc: context.read<SessionsBloc>(),
      )..add(SessionCreatorEventInitialize()),
      child: child,
    );
  }
}
