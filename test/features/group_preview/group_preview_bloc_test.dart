import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_dialogs.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_event.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

class MockGroupPreviewDialogs extends Mock implements GroupPreviewDialogs {}

class MockNavigation extends Mock implements Navigation {}

void main() {
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  final GroupPreviewDialogs groupPreviewDialogs = MockGroupPreviewDialogs();
  final Navigation navigation = MockNavigation();
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
        navigation: navigation);
    when(() => groupsBloc.state).thenReturn(groupsState);
    when(() => groupsBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    when(() => flashcardsBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(groupsBloc);
    reset(coursesBloc);
    reset(flashcardsBloc);
    reset(groupPreviewDialogs);
    reset(navigation);
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
    'edit, group assigned',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToGroupCreator(
          GroupCreatorEditMode(group: groupsState.allGroups[0]),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(GroupPreviewEventInitialize(groupId: 'g1'));
      bloc.add(GroupPreviewEventEdit());
    },
    verify: (_) {
      verify(
        () => navigation.navigateToGroupCreator(
          GroupCreatorEditMode(group: groupsState.allGroups[0]),
        ),
      ).called(1);
    },
  );

  blocTest(
    'edit, group not assigned',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToGroupCreator(
          GroupCreatorEditMode(group: groupsState.allGroups[0]),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(GroupPreviewEventEdit()),
    verify: (_) {
      verifyNever(
        () => navigation.navigateToGroupCreator(
          GroupCreatorEditMode(group: groupsState.allGroups[0]),
        ),
      );
    },
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
    },
  );

  blocTest(
    'edit flashcards, group assigned',
    build: () => bloc,
    setUp: () {
      when(() => navigation.navigateToFlashcardsEditor('g1')).thenReturn(null);
    },
    act: (_) {
      bloc.add(GroupPreviewEventInitialize(groupId: 'g1'));
      bloc.add(GroupPreviewEventEditFlashcards());
    },
    verify: (_) {
      verify(() => navigation.navigateToFlashcardsEditor('g1')).called(1);
    },
  );

  blocTest(
    'edit flashcards, group not assigned',
    build: () => bloc,
    setUp: () {
      when(() => navigation.navigateToFlashcardsEditor('g1')).thenReturn(null);
    },
    act: (_) => bloc.add(GroupPreviewEventEditFlashcards()),
    verify: (_) {
      verifyNever(() => navigation.navigateToFlashcardsEditor('g1'));
    },
  );

  blocTest(
    'review flashcards, group assigned',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToGroupFlashcardsPreview('g1'),
      ).thenReturn(null);
    },
    act: (_) {
      bloc.add(GroupPreviewEventInitialize(groupId: 'g1'));
      bloc.add(GroupPreviewEventReviewFlashcards());
    },
    verify: (_) {
      verify(() => navigation.navigateToGroupFlashcardsPreview('g1')).called(1);
    },
  );

  blocTest(
    'review flashcards, group not assigned',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToGroupFlashcardsPreview('g1'),
      ).thenReturn(null);
    },
    act: (_) => bloc.add(GroupPreviewEventReviewFlashcards()),
    verify: (_) {
      verifyNever(() => navigation.navigateToGroupFlashcardsPreview('g1'));
    },
  );

  blocTest(
    'create quick session, group assigned',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToSessionPreview(
          SessionPreviewModeQuick(groupId: 'g1'),
        ),
      ).thenReturn(null);
    },
    act: (_) {
      bloc.add(GroupPreviewEventInitialize(groupId: 'g1'));
      bloc.add(GroupPreviewEventCreateQuickSession());
    },
    verify: (_) {
      verify(
        () => navigation.navigateToSessionPreview(
          SessionPreviewModeQuick(groupId: 'g1'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'create quick session, group not assigned',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToSessionPreview(
          SessionPreviewModeQuick(groupId: 'g1'),
        ),
      ).thenReturn(null);
    },
    act: (_) => bloc.add(GroupPreviewEventCreateQuickSession()),
    verify: (_) {
      verifyNever(
        () => navigation.navigateToSessionPreview(
          SessionPreviewModeQuick(groupId: 'g1'),
        ),
      );
    },
  );
}
