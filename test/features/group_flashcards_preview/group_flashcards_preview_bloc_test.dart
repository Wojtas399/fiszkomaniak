import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

class MockNavigation extends Mock implements Navigation {}

void main() {
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  final Navigation navigation = MockNavigation();
  late GroupFlashcardsPreviewBloc bloc;
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(
        id: 'g1',
        name: 'group name 1',
        flashcards: [
          createFlashcard(index: 0, question: 'question0', answer: 'answer0'),
          createFlashcard(index: 1, question: 'question1', answer: 'answer1'),
        ],
      ),
      createGroup(
        id: 'g2',
        name: 'group name 2',
        flashcards: [
          createFlashcard(index: 0, question: 'q0', answer: 'a0'),
          createFlashcard(index: 1, question: 'q1', answer: 'a1'),
        ],
      ),
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    groupsState: groupsState,
  );

  setUp(() {
    bloc = GroupFlashcardsPreviewBloc(
      groupsBloc: groupsBloc,
      flashcardsBloc: flashcardsBloc,
      navigation: navigation,
    );
    when(() => groupsBloc.state).thenReturn(groupsState);
    when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    when(() => flashcardsBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(groupsBloc);
    reset(flashcardsBloc);
    reset(navigation);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(GroupFlashcardsPreviewEventInitialize(groupId: 'g1')),
    expect: () => [
      GroupFlashcardsPreviewState(
        groupId: 'g1',
        groupName: 'group name 1',
        flashcardsFromGroup: groupsState.allGroups[0].flashcards,
      ),
    ],
  );

  blocTest(
    'search value changed',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupFlashcardsPreviewEventSearchValueChanged(
        searchValue: 'search value',
      ),
    ),
    expect: () => [
      const GroupFlashcardsPreviewState(searchValue: 'search value'),
    ],
  );

  blocTest(
    'show flashcard details',
    build: () => bloc,
    setUp: () {
      when(() => navigation.navigateToFlashcardPreview('g1', 0))
          .thenReturn(null);
    },
    act: (_) {
      bloc.add(GroupFlashcardsPreviewEventInitialize(groupId: 'g1'));
      bloc.add(
        GroupFlashcardsPreviewEventShowFlashcardDetails(flashcardIndex: 0),
      );
    },
    verify: (_) {
      verify(() => navigation.navigateToFlashcardPreview('g1', 0)).called(1);
    },
  );
}
