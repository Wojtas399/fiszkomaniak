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
        allFlashcards: [],
        status: FlashcardsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'add flashcards, success',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsInterface.addFlashcards([
          snapshots[0].doc,
          snapshots[1].doc,
        ]),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(FlashcardsEventAddFlashcards(flashcards: [
      snapshots[0].doc,
      snapshots[1].doc,
    ])),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      FlashcardsState(status: FlashcardsStatusFlashcardsAdded()),
    ],
    verify: (_) {
      verify(
        () => flashcardsInterface.addFlashcards([
          snapshots[0].doc,
          snapshots[1].doc,
        ]),
      ).called(1);
    },
  );

  blocTest(
    'add flashcards, failure',
    build: () => bloc,
    setUp: () {
      when(
        () => flashcardsInterface.addFlashcards([
          snapshots[0].doc,
          snapshots[1].doc,
        ]),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(FlashcardsEventAddFlashcards(flashcards: [
      snapshots[0].doc,
      snapshots[1].doc,
    ])),
    expect: () => [
      FlashcardsState(status: FlashcardsStatusLoading()),
      const FlashcardsState(status: FlashcardsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => flashcardsInterface.addFlashcards([
          snapshots[0].doc,
          snapshots[1].doc,
        ]),
      ).called(1);
    },
  );
}
