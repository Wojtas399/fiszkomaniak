import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_event.dart';
import 'package:fiszkomaniak/core/sessions/sessions_state.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockSessionsBloc extends Mock implements SessionsBloc {}

class MockSessionPreviewDialogs extends Mock implements SessionPreviewDialogs {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final SessionsBloc sessionsBloc = MockSessionsBloc();
  final SessionPreviewDialogs sessionPreviewDialogs =
      MockSessionPreviewDialogs();
  late SessionPreviewBloc bloc;
  final SessionPreviewMode mode = SessionPreviewModeNormal(sessionId: 's1');
  final SessionsState sessionsState = SessionsState(
    allSessions: [
      createSession(
        id: 's1',
        groupId: 'g1',
        time: const TimeOfDay(hour: 12, minute: 30),
        duration: const TimeOfDay(hour: 0, minute: 25),
        notificationTime: const TimeOfDay(hour: 8, minute: 0),
      ),
      createSession(id: 's2', groupId: 'g2'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', courseId: 'c1'),
      createGroup(id: 'g2', courseId: 'c2'),
    ],
  );
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1', name: 'course 1 name'),
      createCourse(id: 'c2'),
    ],
  );
  final SessionPreviewState initialState = SessionPreviewState(
    mode: SessionPreviewModeNormal(sessionId: 's1'),
    session: sessionsState.allSessions[0],
    group: groupsState.allGroups[0],
    courseName: 'course 1 name',
    duration: sessionsState.allSessions[0].duration,
    flashcardsType: FlashcardsType.all,
    areQuestionsAndAnswersSwapped: false,
  );

  setUp(() {
    bloc = SessionPreviewBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      sessionsBloc: sessionsBloc,
      sessionPreviewDialogs: sessionPreviewDialogs,
    );
    when(() => sessionsBloc.state).thenReturn(sessionsState);
    when(() => groupsBloc.state).thenReturn(groupsState);
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => sessionsBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(sessionsBloc);
    reset(sessionPreviewDialogs);
  });

  blocTest(
    'initialize normal mode',
    build: () => bloc,
    act: (_) => bloc.add(SessionPreviewEventInitialize(mode: mode)),
    expect: () => [initialState],
  );

  blocTest(
    'initialize quick mode',
    build: () => bloc,
    act: (_) => bloc.add(SessionPreviewEventInitialize(
      mode: SessionPreviewModeQuick(groupId: 'g1'),
    )),
    expect: () => [
      SessionPreviewState(
        mode: SessionPreviewModeQuick(groupId: 'g1'),
        group: groupsState.allGroups[0],
        courseName: 'course 1 name',
        flashcardsType: FlashcardsType.all,
        areQuestionsAndAnswersSwapped: false,
      ),
    ],
  );

  blocTest(
    'initialize, elements not found',
    build: () => bloc,
    act: (_) => bloc.add(SessionPreviewEventInitialize(
      mode: SessionPreviewModeNormal(sessionId: 's3'),
    )),
    expect: () => [],
  );

  blocTest(
    'duration changed',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(mode: mode));
      bloc.add(SessionPreviewEventDurationChanged(
        duration: const TimeOfDay(hour: 1, minute: 0),
      ));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        duration: const TimeOfDay(hour: 1, minute: 0),
      ),
    ],
  );

  blocTest(
    'flashcards type changed',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(mode: mode));
      bloc.add(SessionPreviewEventFlashcardsTypeChanged(
        flashcardsType: FlashcardsType.remembered,
      ));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        duration: initialState.duration,
        flashcardsType: FlashcardsType.remembered,
      ),
    ],
  );

  blocTest(
    'swap questions and answers',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(mode: mode));
      bloc.add(SessionPreviewEventSwapQuestionsAndAnswers());
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        duration: initialState.duration,
        areQuestionsAndAnswersSwapped: true,
      ),
    ],
  );

  blocTest(
    'swap questions and answers, initial value as null',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventSwapQuestionsAndAnswers());
    },
    expect: () => [],
  );

  blocTest(
    'delete session, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => sessionPreviewDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(mode: mode));
      bloc.add(SessionPreviewEventDeleteSession());
    },
    verify: (_) {
      verify(
        () => sessionsBloc.add(SessionsEventRemoveSession(sessionId: 's1')),
      ).called(1);
    },
  );

  blocTest(
    'delete session, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => sessionPreviewDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(mode: mode));
      bloc.add(SessionPreviewEventDeleteSession());
    },
    verify: (_) {
      verifyNever(
        () => sessionsBloc.add(SessionsEventRemoveSession(sessionId: 's1')),
      );
    },
  );
}
