import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_event.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
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
  late FlashcardPreviewBloc bloc;
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1', name: 'course 1 name'),
      createCourse(id: 'c2', name: 'course 2 name'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', courseId: 'c1'),
      createGroup(id: 'g2', courseId: 'c1'),
      createGroup(id: 'g3', courseId: 'c2'),
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    allFlashcards: [
      createFlashcard(id: 'f1', groupId: 'g1'),
      createFlashcard(id: 'f2', groupId: 'g1'),
      createFlashcard(id: 'f3', groupId: 'g3'),
    ],
  );

  setUp(() {
    bloc = FlashcardPreviewBloc(
      flashcardsBloc: flashcardsBloc,
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
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
      when(() => groupsBloc.state).thenReturn(groupsState);
      when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    },
    act: (_) => bloc.add(FlashcardPreviewEventInitialize(flashcardId: 'f1')),
    expect: () => [
      FlashcardPreviewState(
        flashcard: flashcardsState.allFlashcards[0],
        group: groupsState.allGroups[0],
        courseName: coursesState.allCourses[0].name,
      ),
    ],
  );
}
