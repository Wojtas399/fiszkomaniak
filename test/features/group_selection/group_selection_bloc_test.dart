import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_event.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  late GroupSelectionBloc bloc;
  final List<Course> courses = [
    createCourse(id: 'c1'),
    createCourse(id: 'c2'),
    createCourse(id: 'c3'),
  ];
  final List<Group> groups = [
    createGroup(id: 'g1', courseId: 'c1'),
    createGroup(id: 'g2', courseId: 'c2'),
    createGroup(id: 'g3', courseId: 'c3'),
    createGroup(id: 'g4', courseId: 'c1'),
  ];
  final List<Flashcard> flashcards = [
    createFlashcard(
      id: 'f1',
      groupId: 'g1',
      status: FlashcardStatus.remembered,
    ),
    createFlashcard(id: 'f2', groupId: 'g1'),
    createFlashcard(id: 'f3', groupId: 'g1'),
    createFlashcard(id: 'f4', groupId: 'g2'),
    createFlashcard(id: 'f5', groupId: 'g4'),
  ];

  setUp(() {
    bloc = GroupSelectionBloc(
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
      when(() => coursesBloc.state).thenReturn(
        CoursesState(allCourses: courses),
      );
    },
    act: (_) => bloc.add(GroupSelectionEventInitialize()),
    expect: () => [
      GroupSelectionState(allCourses: courses),
    ],
  );

  blocTest(
    'course selected',
    build: () => bloc,
    setUp: () {
      when(() => coursesBloc.state).thenReturn(
        CoursesState(allCourses: courses),
      );
      when(() => groupsBloc.state).thenReturn(
        GroupsState(allGroups: groups),
      );
    },
    act: (_) => bloc.add(GroupSelectionEventCourseSelected(courseId: 'c1')),
    expect: () => [
      GroupSelectionState(
        selectedCourse: courses[0],
        groupsFromCourse: [
          groups[0],
          groups[3],
        ],
      ),
    ],
  );

  blocTest(
    'group selected',
    build: () => bloc,
    setUp: () {
      when(() => groupsBloc.state).thenReturn(
        GroupsState(allGroups: groups),
      );
      when(() => flashcardsBloc.state).thenReturn(
        FlashcardsState(allFlashcards: flashcards),
      );
    },
    act: (_) => bloc.add(GroupSelectionEventGroupSelected(groupId: 'g1')),
    expect: () => [
      GroupSelectionState(
        selectedGroup: groups[0],
        amountOfAllFlashcardsFromGroup: 3,
        amountOfRememberedFlashcardsFromGroup: 1,
      ),
    ],
  );
}
