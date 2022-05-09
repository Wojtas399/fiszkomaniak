import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/repositories/flashcards_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_flashcards_service.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireFlashcardsService extends Mock implements FireFlashcardsService {}

void main() {
  final FireFlashcardsService fireFlashcardsService =
      MockFireFlashcardsService();
  late FlashcardsRepository repository;
  final List<Flashcard> flashcards = [
    createFlashcard(
      index: 0,
      question: 'f1 question',
      answer: 'f1 answer',
      status: FlashcardStatus.notRemembered,
    ),
    createFlashcard(
      index: 1,
      question: 'f2 question',
      answer: 'f2 answer',
      status: FlashcardStatus.remembered,
    ),
  ];
  final List<FlashcardDbModel> convertedFlashcards = [
    FlashcardDbModel(
      index: flashcards[0].index,
      question: flashcards[0].question,
      answer: flashcards[0].answer,
      status: 'notRemembered',
    ),
    FlashcardDbModel(
      index: flashcards[1].index,
      question: flashcards[1].question,
      answer: flashcards[1].answer,
      status: 'remembered',
    ),
  ];

  setUp(() {
    repository = FlashcardsRepository(
      fireFlashcardsService: fireFlashcardsService,
    );
  });

  tearDown(() {
    reset(fireFlashcardsService);
  });

  test('set flashcards', () async {
    when(() => fireFlashcardsService.setFlashcards('g1', convertedFlashcards))
        .thenAnswer((_) async => '');

    await repository.setFlashcards(groupId: 'g1', flashcards: flashcards);

    verify(() => fireFlashcardsService.setFlashcards('g1', convertedFlashcards))
        .called(1);
  });

  test('update flashcard', () async {
    when(
      () => fireFlashcardsService.updateFlashcard('g1', convertedFlashcards[0]),
    ).thenAnswer((_) async => '');

    await repository.updateFlashcard(groupId: 'g1', flashcard: flashcards[0]);

    verify(
      () => fireFlashcardsService.updateFlashcard('g1', convertedFlashcards[0]),
    ).called(1);
  });

  test('remove flashcard', () async {
    when(
      () => fireFlashcardsService.removeFlashcard('g1', convertedFlashcards[0]),
    ).thenAnswer((_) async => '');

    await repository.removeFlashcard(groupId: 'g1', flashcard: flashcards[0]);

    verify(
      () => fireFlashcardsService.removeFlashcard('g1', convertedFlashcards[0]),
    ).called(1);
  });
}
