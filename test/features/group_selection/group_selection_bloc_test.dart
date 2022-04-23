import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/config/navigation.dart';
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

class MockNavigation extends Mock implements Navigation {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  final Navigation navigation = MockNavigation();
  late GroupSelectionBloc bloc;
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1'),
      createCourse(id: 'c2'),
      createCourse(id: 'c3'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', courseId: 'c1'),
      createGroup(id: 'g2', courseId: 'c2'),
      createGroup(id: 'g3', courseId: 'c3'),
      createGroup(id: 'g4', courseId: 'c1'),
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    allFlashcards: [
      createFlashcard(
        id: 'f1',
        groupId: 'g1',
        status: FlashcardStatus.remembered,
      ),
      createFlashcard(id: 'f2', groupId: 'g1'),
      createFlashcard(id: 'f3', groupId: 'g1'),
      createFlashcard(id: 'f4', groupId: 'g2'),
      createFlashcard(id: 'f5', groupId: 'g4'),
    ],
  );

  setUp(() {
    bloc = GroupSelectionBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      flashcardsBloc: flashcardsBloc,
      navigation: navigation,
    );
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => groupsBloc.state).thenReturn(groupsState);
    when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    when(() => flashcardsBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(flashcardsBloc);
    reset(navigation);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(GroupSelectionEventInitialize()),
    expect: () => [
      GroupSelectionState(allCourses: coursesState.allCourses),
    ],
  );

  blocTest(
    'course selected',
    build: () => bloc,
    act: (_) => bloc.add(GroupSelectionEventCourseSelected(courseId: 'c1')),
    expect: () => [
      GroupSelectionState(
        selectedCourse: coursesState.allCourses[0],
        groupsFromCourse: [
          groupsState.allGroups[0],
          groupsState.allGroups[3],
        ],
      ),
    ],
  );

  blocTest(
    'group selected',
    build: () => bloc,
    act: (_) => bloc.add(GroupSelectionEventGroupSelected(groupId: 'g1')),
    expect: () => [
      GroupSelectionState(
        selectedGroup: groupsState.allGroups[0],
        amountOfAllFlashcardsFromGroup: 3,
        amountOfRememberedFlashcardsFromGroup: 1,
      ),
    ],
  );

  blocTest(
    'button pressed',
    build: () => bloc,
    setUp: () {
      when(() => navigation.navigateToFlashcardsEditor('g1')).thenReturn(null);
    },
    act: (_) {
      bloc.add(GroupSelectionEventGroupSelected(groupId: 'g1'));
      bloc.add(GroupSelectionEventButtonPressed());
    },
    verify: (_) {
      verify(() => navigation.navigateToFlashcardsEditor('g1')).called(1);
    },
  );
}
