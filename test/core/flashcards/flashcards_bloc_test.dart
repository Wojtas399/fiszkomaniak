import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlashcardsInterface extends Mock implements FlashcardsInterface {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

void main() {
  final FlashcardsInterface flashcardsInterface = MockFlashcardsInterface();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  late FlashcardsBloc bloc;
  final List<Flashcard> flashcards = [
    createFlashcard(index: 0),
    createFlashcard(index: 2),
    createFlashcard(index: 5),
  ];

  setUp(() {
    bloc = FlashcardsBloc(
      flashcardsInterface: flashcardsInterface,
      groupsBloc: groupsBloc,
    );
  });

  tearDown(() {
    reset(flashcardsInterface);
    reset(groupsBloc);
  });

  blocTest(
    'groups state updated',
    build: () => bloc,
    act: (_) => bloc.add(FlashcardsEventGroupsStateUpdated(
      newGroupsState: GroupsState(
        allGroups: [createGroup(id: 'g1'), createGroup(id: 'g2')],
      ),
    )),
    expect: () => [
      FlashcardsState(
        groupsState: GroupsState(
          allGroups: [createGroup(id: 'g1'), createGroup(id: 'g2')],
        ),
        status: FlashcardsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'save flashcards, success',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsInterface.setFlashcards(
          groupId: 'g1',
          flashcards: flashcards,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(FlashcardsEventSaveFlashcards(
      groupId: 'g1',
      flashcards: flashcards,
    )),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardsSaved()),
    ],
    verify: (_) {
      verify(
        () => flashcardsInterface.setFlashcards(
          groupId: 'g1',
          flashcards: flashcards,
        ),
      ).called(1);
    },
  );

  blocTest(
    'save flashcards, failure',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsInterface.setFlashcards(
          groupId: 'g1',
          flashcards: flashcards,
        ),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(FlashcardsEventSaveFlashcards(
      groupId: 'g1',
      flashcards: flashcards,
    )),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      const FlashcardsState(status: FlashcardsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => flashcardsInterface.setFlashcards(
          groupId: 'g1',
          flashcards: flashcards,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update flashcard, success',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsInterface.updateFlashcard(
          groupId: 'g1',
          flashcard: flashcards[0],
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      FlashcardsEventUpdateFlashcard(groupId: 'g1', flashcard: flashcards[0]),
    ),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardUpdated()),
    ],
    verify: (_) {
      verify(
        () => flashcardsInterface.updateFlashcard(
          groupId: 'g1',
          flashcard: flashcards[0],
        ),
      ).called(1);
    },
  );

  blocTest(
    'update flashcard, failure',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsInterface.updateFlashcard(
          groupId: 'g1',
          flashcard: flashcards[0],
        ),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(
      FlashcardsEventUpdateFlashcard(groupId: 'g1', flashcard: flashcards[0]),
    ),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      const FlashcardsState(status: FlashcardsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => flashcardsInterface.updateFlashcard(
          groupId: 'g1',
          flashcard: flashcards[0],
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove flashcard, success',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsInterface.removeFlashcard(
          groupId: 'g1',
          flashcard: flashcards[0],
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      FlashcardsEventRemoveFlashcard(groupId: 'g1', flashcard: flashcards[0]),
    ),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardRemoved()),
    ],
    verify: (_) {
      verify(
        () => flashcardsInterface.removeFlashcard(
          groupId: 'g1',
          flashcard: flashcards[0],
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove flashcard, failure',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsInterface.removeFlashcard(
          groupId: 'g1',
          flashcard: flashcards[0],
        ),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(
      FlashcardsEventRemoveFlashcard(groupId: 'g1', flashcard: flashcards[0]),
    ),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      const FlashcardsState(status: FlashcardsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => flashcardsInterface.removeFlashcard(
          groupId: 'g1',
          flashcard: flashcards[0],
        ),
      ).called(1);
    },
  );
}
