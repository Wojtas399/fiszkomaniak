import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  late SessionCreatorBloc bloc;
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1'),
      createCourse(id: 'c2'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', courseId: 'c1'),
      createGroup(id: 'g2', courseId: 'c1'),
      createGroup(id: 'g3', courseId: 'c2'),
      createGroup(id: 'g4', courseId: 'c1'),
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    allFlashcards: [
      createFlashcard(id: 'f1', groupId: 'g1'),
      createFlashcard(id: 'f2', groupId: 'g2'),
      createFlashcard(id: 'f3', groupId: 'g3'),
      createFlashcard(id: 'f4', groupId: 'g1'),
    ],
  );

  setUp(() {
    bloc = SessionCreatorBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      flashcardsBloc: flashcardsBloc,
    );
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(flashcardsBloc);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    setUp: () {
      when(() => coursesBloc.state).thenReturn(coursesState);
    },
    act: (_) => bloc.add(SessionCreatorEventInitialize()),
    expect: () => [
      SessionCreatorState(courses: coursesState.allCourses),
    ],
  );

  blocTest(
    'course selected, different than current',
    build: () => bloc,
    setUp: () {
      when(() => coursesBloc.state).thenReturn(coursesState);
      when(() => groupsBloc.state).thenReturn(groupsState);
      when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    },
    act: (_) {
      bloc.add(SessionCreatorEventCourseSelected(courseId: 'c2'));
      bloc.add(SessionCreatorEventGroupSelected(groupId: 'g2'));
      bloc.add(SessionCreatorEventCourseSelected(courseId: 'c1'));
    },
    expect: () => [
      SessionCreatorState(
        selectedCourse: coursesState.allCourses[1],
        groups: [
          groupsState.allGroups[2],
        ],
      ),
      SessionCreatorState(
        selectedCourse: coursesState.allCourses[1],
        selectedGroup: groupsState.allGroups[1],
        groups: [
          groupsState.allGroups[2],
        ],
      ),
      SessionCreatorState(
        selectedCourse: coursesState.allCourses[1],
        selectedGroup: null,
        groups: [
          groupsState.allGroups[2],
        ],
      ),
      SessionCreatorState(
        selectedCourse: coursesState.allCourses[0],
        selectedGroup: null,
        groups: [
          groupsState.allGroups[0],
          groupsState.allGroups[1],
        ],
      ),
    ],
  );

  blocTest(
    'course selected, the same',
    build: () => bloc,
    setUp: () {
      when(() => coursesBloc.state).thenReturn(coursesState);
      when(() => groupsBloc.state).thenReturn(groupsState);
      when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    },
    act: (_) {
      bloc.add(SessionCreatorEventCourseSelected(courseId: 'c1'));
      bloc.add(SessionCreatorEventGroupSelected(groupId: 'g2'));
      bloc.add(SessionCreatorEventCourseSelected(courseId: 'c1'));
    },
    expect: () => [
      SessionCreatorState(
        selectedCourse: coursesState.allCourses[0],
        groups: [
          groupsState.allGroups[0],
          groupsState.allGroups[1],
        ],
      ),
      SessionCreatorState(
        selectedCourse: coursesState.allCourses[0],
        selectedGroup: groupsState.allGroups[1],
        groups: [
          groupsState.allGroups[0],
          groupsState.allGroups[1],
        ],
      ),
    ],
  );

  blocTest(
    'group selected',
    build: () => bloc,
    setUp: () {
      when(() => groupsBloc.state).thenReturn(groupsState);
    },
    act: (_) => bloc.add(SessionCreatorEventGroupSelected(groupId: 'g1')),
    expect: () => [
      SessionCreatorState(selectedGroup: groupsState.allGroups[0]),
    ],
  );

  blocTest(
    'flashcards type selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventFlashcardsTypeSelected(
      type: FlashcardsType.remembered,
    )),
    expect: () => [
      const SessionCreatorState(flashcardsType: FlashcardsType.remembered),
    ],
  );

  blocTest(
    'swap questions with answer, group not selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventSwapQuestionsWithAnswers()),
    expect: () => [],
  );

  blocTest(
    'swap questions with answer, group selected',
    build: () => bloc,
    setUp: () {
      when(() => groupsBloc.state).thenReturn(groupsState);
    },
    act: (_) {
      bloc.add(SessionCreatorEventGroupSelected(groupId: 'g1'));
      bloc.add(SessionCreatorEventSwapQuestionsWithAnswers());
    },
    expect: () => [
      SessionCreatorState(selectedGroup: groupsState.allGroups[0]),
      SessionCreatorState(
        selectedGroup: groupsState.allGroups[0],
        reversedQuestionsWithAnswers: true,
      ),
    ],
  );

  blocTest(
    'date selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventDateSelected(date: DateTime(2022))),
    expect: () => [
      SessionCreatorState(
        date: DateTime(2022),
      ),
    ],
  );

  blocTest(
    'time selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventTimeSelected(
      time: const TimeOfDay(hour: 14, minute: 0),
    )),
    expect: () => [
      const SessionCreatorState(
        time: TimeOfDay(hour: 14, minute: 0),
      ),
    ],
  );

  blocTest(
    'duration selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventDurationSelected(
      duration: const TimeOfDay(hour: 0, minute: 30),
    )),
    expect: () => [
      const SessionCreatorState(
        duration: TimeOfDay(hour: 0, minute: 30),
      ),
    ],
  );

  blocTest(
    'notification time selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventNotificationTimeSelected(
      notificationTime: const TimeOfDay(hour: 12, minute: 30),
    )),
    expect: () => [
      const SessionCreatorState(
        notificationTime: TimeOfDay(hour: 12, minute: 30),
      ),
    ],
  );

  blocTest(
    'clean notification time',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionCreatorEventNotificationTimeSelected(
        notificationTime: const TimeOfDay(hour: 12, minute: 30),
      ));
      bloc.add(SessionCreatorEventCleanNotificationTime());
    },
    expect: () => [
      const SessionCreatorState(
        notificationTime: TimeOfDay(hour: 12, minute: 30),
      ),
      const SessionCreatorState(
        notificationTime: null,
      ),
    ],
  );
}
