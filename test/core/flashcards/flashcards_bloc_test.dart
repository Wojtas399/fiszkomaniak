import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlashcardsInterface extends Mock implements FlashcardsInterface {}

void main() {
  final FlashcardsInterface flashcardsInterface = MockFlashcardsInterface();
  late FlashcardsBloc bloc;
  final List<ChangedDocument<Flashcard>> snapshots = [
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createFlashcard(id: 'f1'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createFlashcard(id: 'f2'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createFlashcard(id: 'f3', question: 'What is your name?'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.updated,
      doc: createFlashcard(id: 'f3', question: 'How old are you?'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.removed,
      doc: createFlashcard(id: 'f3'),
    ),
  ];

  setUp(() {
    bloc = FlashcardsBloc(flashcardsInterface: flashcardsInterface);
  });

  tearDown(() {
    reset(flashcardsInterface);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.getFlashcardsSnapshots()).thenAnswer(
        (_) => Stream.value(snapshots),
      );
    },
    act: (_) => bloc.add(FlashcardsEventInitialize()),
    expect: () => [
      FlashcardsState(
        allFlashcards: [
          snapshots[0].doc,
        ],
        status: FlashcardsStatusLoaded(),
      ),
      FlashcardsState(
        allFlashcards: [
          snapshots[0].doc,
          snapshots[1].doc,
        ],
        status: FlashcardsStatusLoaded(),
      ),
      FlashcardsState(
        allFlashcards: [
          snapshots[0].doc,
          snapshots[1].doc,
          snapshots[2].doc,
        ],
        status: FlashcardsStatusLoaded(),
      ),
      FlashcardsState(
        allFlashcards: [
          snapshots[0].doc,
          snapshots[1].doc,
          snapshots[3].doc,
        ],
        status: FlashcardsStatusLoaded(),
      ),
      FlashcardsState(
        allFlashcards: [
          snapshots[0].doc,
          snapshots[1].doc,
        ],
        status: FlashcardsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'flashcard added',
    build: () => bloc,
    act: (_) => bloc.add(
      FlashcardsEventFlashcardAdded(flashcard: snapshots[0].doc),
    ),
    expect: () => [
      FlashcardsState(
        allFlashcards: [snapshots[0].doc],
        status: FlashcardsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'flashcard updated',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEventFlashcardAdded(flashcard: snapshots[2].doc));
      bloc.add(FlashcardsEventFlashcardUpdated(flashcard: snapshots[3].doc));
    },
    expect: () => [
      FlashcardsState(
        allFlashcards: [snapshots[2].doc],
        status: FlashcardsStatusLoaded(),
      ),
      FlashcardsState(
        allFlashcards: [snapshots[3].doc],
        status: FlashcardsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'flashcard removed',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsEventFlashcardAdded(flashcard: snapshots[0].doc));
      bloc.add(FlashcardsEventFlashcardRemoved(flashcardId: 'f1'));
    },
    expect: () => [
      FlashcardsState(
        allFlashcards: [snapshots[0].doc],
        status: FlashcardsStatusLoaded(),
      ),
      FlashcardsState(
        allFlashcards: const [],
        status: FlashcardsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'save multiple actions, only flashcards to add, success',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.addFlashcards([snapshots[0].doc]))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(FlashcardsEventSaveMultipleActions(
      flashcardsToUpdate: const [],
      flashcardsToAdd: [snapshots[0].doc],
      idsOfFlashcardsToRemove: const [],
    )),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardsAdded()),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.addFlashcards([snapshots[0].doc]))
          .called(1);
      verifyNever(() => flashcardsInterface.updateFlashcards([]));
      verifyNever(() => flashcardsInterface.removeFlashcards([]));
    },
  );

  blocTest(
    'save multiple actions, only flashcards to update, success',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.updateFlashcards([snapshots[0].doc]))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(FlashcardsEventSaveMultipleActions(
      flashcardsToUpdate: [snapshots[0].doc],
      flashcardsToAdd: const [],
      idsOfFlashcardsToRemove: const [],
    )),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardsSaved()),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.updateFlashcards([snapshots[0].doc]))
          .called(1);
      verifyNever(() => flashcardsInterface.addFlashcards([]));
      verifyNever(() => flashcardsInterface.removeFlashcards([]));
    },
  );

  blocTest(
    'save multiple actions, only flashcards to remove, success',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.removeFlashcards(['f1']))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(FlashcardsEventSaveMultipleActions(
      flashcardsToUpdate: const [],
      flashcardsToAdd: const [],
      idsOfFlashcardsToRemove: const ['f1'],
    )),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardsSaved()),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.removeFlashcards(['f1'])).called(1);
      verifyNever(() => flashcardsInterface.addFlashcards([]));
      verifyNever(() => flashcardsInterface.updateFlashcards([]));
    },
  );

  blocTest(
    'save multiple actions, success',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.addFlashcards([snapshots[0].doc]))
          .thenAnswer((_) async => '');
      when(() => flashcardsInterface.updateFlashcards([snapshots[1].doc]))
          .thenAnswer((_) async => '');
      when(() => flashcardsInterface.removeFlashcards(['f3']))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(FlashcardsEventSaveMultipleActions(
      flashcardsToUpdate: [snapshots[1].doc],
      flashcardsToAdd: [snapshots[0].doc],
      idsOfFlashcardsToRemove: const ['f3'],
    )),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardsSaved()),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.addFlashcards([snapshots[0].doc]))
          .called(1);
      verify(() => flashcardsInterface.updateFlashcards([snapshots[1].doc]))
          .called(1);
      verify(() => flashcardsInterface.removeFlashcards(['f3'])).called(1);
    },
  );

  blocTest(
    'save multiple actions, failure',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.updateFlashcards([snapshots[1].doc]))
          .thenAnswer((_) async => '');
      when(() => flashcardsInterface.addFlashcards([snapshots[0].doc]))
          .thenThrow('Error...');
    },
    act: (_) => bloc.add(FlashcardsEventSaveMultipleActions(
      flashcardsToUpdate: [snapshots[1].doc],
      flashcardsToAdd: [snapshots[0].doc],
      idsOfFlashcardsToRemove: const ['f3'],
    )),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      const FlashcardsState(status: FlashcardsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.addFlashcards([snapshots[0].doc]))
          .called(1);
      verify(() => flashcardsInterface.updateFlashcards([snapshots[1].doc]))
          .called(1);
      verifyNever(() => flashcardsInterface.removeFlashcards(['f3']));
    },
  );

  blocTest(
    'update flashcard, success',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.updateFlashcards([snapshots[0].doc]))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      FlashcardsEventUpdateFlashcard(flashcard: snapshots[0].doc),
    ),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardUpdated()),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.updateFlashcards([snapshots[0].doc]))
          .called(1);
    },
  );

  blocTest(
    'update flashcard, failure',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.updateFlashcards([snapshots[0].doc]))
          .thenThrow('Error...');
    },
    act: (_) => bloc.add(
      FlashcardsEventUpdateFlashcard(flashcard: snapshots[0].doc),
    ),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      const FlashcardsState(status: FlashcardsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.updateFlashcards([snapshots[0].doc]))
          .called(1);
    },
  );

  blocTest(
    'remove flashcard, success',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.removeFlashcards([snapshots[0].doc.id]))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      FlashcardsEventRemoveFlashcard(flashcardId: snapshots[0].doc.id),
    ),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardRemoved()),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.removeFlashcards([snapshots[0].doc.id]))
          .called(1);
    },
  );

  blocTest(
    'remove flashcard, failure',
    build: () => bloc,
    setUp: () {
      when(() => flashcardsInterface.removeFlashcards([snapshots[0].doc.id]))
          .thenThrow('Error...');
    },
    act: (_) => bloc.add(
      FlashcardsEventRemoveFlashcard(flashcardId: snapshots[0].doc.id),
    ),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      const FlashcardsState(status: FlashcardsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => flashcardsInterface.removeFlashcards([snapshots[0].doc.id]))
          .called(1);
    },
  );
}
