import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_state.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockSessionsBloc extends Mock implements SessionsBloc {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final SessionsBloc sessionsBloc = MockSessionsBloc();
  late SessionPreviewBloc bloc;
  final SessionsState sessionsState = SessionsState(
    allSessions: [
      createSession(id: 's1', groupId: 'g1'),
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

  setUp(() {
    bloc = SessionPreviewBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      sessionsBloc: sessionsBloc,
    );
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(sessionsBloc);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    setUp: () {
      when(() => sessionsBloc.state).thenReturn(sessionsState);
      when(() => groupsBloc.state).thenReturn(groupsState);
      when(() => coursesBloc.state).thenReturn(coursesState);
    },
    act: (_) => bloc.add(SessionPreviewEventInitialize(sessionId: 's1')),
    expect: () => [
      SessionPreviewState(
        session: sessionsState.allSessions[0],
        group: groupsState.allGroups[0],
        courseName: 'course 1 name',
      ),
    ],
  );

  blocTest(
    'initialize, elements not found',
    build: () => bloc,
    setUp: () {
      when(() => sessionsBloc.state).thenReturn(sessionsState);
      when(() => groupsBloc.state).thenReturn(groupsState);
      when(() => coursesBloc.state).thenReturn(coursesState);
    },
    act: (_) => bloc.add(SessionPreviewEventInitialize(sessionId: 's3')),
    expect: () => [],
  );
}
