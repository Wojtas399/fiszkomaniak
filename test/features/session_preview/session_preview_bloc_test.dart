import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_state.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
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
    mode: SessionMode.normal,
    session: sessionsState.allSessions[0],
    group: groupsState.allGroups[0],
    courseName: 'course 1 name',
    time: sessionsState.allSessions[0].time,
    duration: sessionsState.allSessions[0].duration,
    notificationTime: sessionsState.allSessions[0].notificationTime,
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
    'initialize without mode',
    build: () => bloc,
    act: (_) => bloc.add(SessionPreviewEventInitialize(sessionId: 's1')),
    expect: () => [initialState],
  );

  blocTest(
    'initialize with mode',
    build: () => bloc,
    act: (_) => bloc.add(SessionPreviewEventInitialize(
      sessionId: 's1',
      mode: SessionMode.quick,
    )),
    expect: () => [
      initialState.copyWith(
        mode: SessionMode.quick,
        duration: initialState.duration,
        notificationTime: initialState.notificationTime,
      ),
    ],
  );

  blocTest(
    'initialize, elements not found',
    build: () => bloc,
    act: (_) => bloc.add(SessionPreviewEventInitialize(sessionId: 's3')),
    expect: () => [],
  );

  blocTest(
    'time changed',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(sessionId: 's1'));
      bloc.add(SessionPreviewEventTimeChanged(
        time: const TimeOfDay(hour: 20, minute: 0),
      ));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        time: const TimeOfDay(hour: 20, minute: 0),
        duration: initialState.duration,
        notificationTime: initialState.notificationTime,
      ),
    ],
  );

  blocTest(
    'duration changed',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(sessionId: 's1'));
      bloc.add(SessionPreviewEventDurationChanged(
        duration: const TimeOfDay(hour: 1, minute: 0),
      ));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        duration: const TimeOfDay(hour: 1, minute: 0),
        notificationTime: initialState.notificationTime,
      ),
    ],
  );

  blocTest(
    'notification time changed',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(sessionId: 's1'));
      bloc.add(SessionPreviewEventNotificationTimeChanged(
        notificationTime: const TimeOfDay(hour: 10, minute: 0),
      ));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        duration: initialState.duration,
        notificationTime: const TimeOfDay(hour: 10, minute: 0),
      ),
    ],
  );

  blocTest(
    'flashcards type changed',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(sessionId: 's1'));
      bloc.add(SessionPreviewEventFlashcardsTypeChanged(
        flashcardsType: FlashcardsType.remembered,
      ));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        duration: initialState.duration,
        notificationTime: initialState.notificationTime,
        flashcardsType: FlashcardsType.remembered,
      ),
    ],
  );

  blocTest(
    'swap questions and answers',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(sessionId: 's1'));
      bloc.add(SessionPreviewEventSwapQuestionsAndAnswers());
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        duration: initialState.duration,
        notificationTime: initialState.notificationTime,
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
    'reset changes',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionPreviewEventInitialize(sessionId: 's1'));
      bloc.add(SessionPreviewEventTimeChanged(
        time: const TimeOfDay(hour: 21, minute: 0),
      ));
      bloc.add(SessionPreviewEventDurationChanged(
        duration: const TimeOfDay(hour: 0, minute: 45),
      ));
      bloc.add(SessionPreviewEventNotificationTimeChanged(
        notificationTime: const TimeOfDay(hour: 6, minute: 0),
      ));
      bloc.add(SessionPreviewEventFlashcardsTypeChanged(
        flashcardsType: FlashcardsType.notRemembered,
      ));
      bloc.add(SessionPreviewEventResetChanges());
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        time: const TimeOfDay(hour: 21, minute: 0),
        duration: initialState.duration,
        notificationTime: initialState.notificationTime,
      ),
      initialState.copyWith(
        time: const TimeOfDay(hour: 21, minute: 0),
        duration: const TimeOfDay(hour: 0, minute: 45),
        notificationTime: initialState.notificationTime,
      ),
      initialState.copyWith(
        time: const TimeOfDay(hour: 21, minute: 0),
        duration: const TimeOfDay(hour: 0, minute: 45),
        notificationTime: const TimeOfDay(hour: 6, minute: 0),
      ),
      initialState.copyWith(
        time: const TimeOfDay(hour: 21, minute: 0),
        duration: const TimeOfDay(hour: 0, minute: 45),
        notificationTime: const TimeOfDay(hour: 6, minute: 0),
        flashcardsType: FlashcardsType.notRemembered,
      ),
      initialState,
    ],
  );
}
