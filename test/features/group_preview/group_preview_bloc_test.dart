import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_dialogs.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_event.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

class MockGroupPreviewDialogs extends Mock implements GroupPreviewDialogs {}

void main() {
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  final GroupPreviewDialogs groupPreviewDialogs = MockGroupPreviewDialogs();
  late GroupPreviewBloc bloc;
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
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    allFlashcards: [
      createFlashcard(
        id: 'f1',
        groupId: 'g1',
        status: FlashcardStatus.remembered,
      ),
      createFlashcard(
        id: 'f2',
        groupId: 'g1',
        status: FlashcardStatus.remembered,
      ),
      createFlashcard(
        id: 'f3',
        groupId: 'g1',
        status: FlashcardStatus.notRemembered,
      ),
      createFlashcard(
        id: 'f4',
        groupId: 'g1',
        status: FlashcardStatus.notRemembered,
      ),
      createFlashcard(
        id: 'f5',
        groupId: 'g1',
        status: FlashcardStatus.notRemembered,
      ),
      createFlashcard(id: 'f6', groupId: 'g2'),
      createFlashcard(id: 'f7', groupId: 'g3'),
    ],
  );

  setUp(() {
    bloc = GroupPreviewBloc(
      groupsBloc: groupsBloc,
      coursesBloc: coursesBloc,
      flashcardsBloc: flashcardsBloc,
      groupPreviewDialogs: groupPreviewDialogs,
    );
    when(() => groupsBloc.state).thenReturn(groupsState);
    when(() => groupsBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    when(() => flashcardsBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(groupsBloc);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(GroupPreviewEventInitialize(groupId: 'g1')),
    expect: () => [
      GroupPreviewState(
        group: groupsState.allGroups[0],
        courseName: coursesState.allCourses[0].name,
        amountOfAllFlashcards: 5,
        amountOfRememberedFlashcards: 2,
      ),
    ],
  );

  blocTest(
    'remove, group exists, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => groupPreviewDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(GroupPreviewEventInitialize(groupId: 'g1'));
      bloc.add(GroupPreviewEventRemove());
    },
    verify: (_) {
      verify(
        () => groupsBloc.add(GroupsEventRemoveGroup(groupId: 'g1')),
      ).called(1);
      verify(
        () => flashcardsBloc.add(
          FlashcardsEventRemoveFlashcardsFromGroups(groupsIds: const ['g1']),
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove, group exists, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => groupPreviewDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(GroupPreviewEventInitialize(groupId: 'g1'));
      bloc.add(GroupPreviewEventRemove());
    },
    verify: (_) {
      verifyNever(() => groupsBloc.add(GroupsEventRemoveGroup(groupId: 'g1')));
      verifyNever(
        () => flashcardsBloc.add(
          FlashcardsEventRemoveFlashcardsFromGroups(groupsIds: const ['g1']),
        ),
      );
    },
  );

  blocTest(
    'remove, group does not exist',
    build: () => bloc,
    setUp: () {
      when(() => groupPreviewDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(GroupPreviewEventRemove());
    },
    expect: () => [],
    verify: (_) {
      verifyNever(() => groupsBloc.add(GroupsEventRemoveGroup(groupId: 'g1')));
      verifyNever(
        () => flashcardsBloc.add(
          FlashcardsEventRemoveFlashcardsFromGroups(groupsIds: const ['g1']),
        ),
      );
    },
  );
}
