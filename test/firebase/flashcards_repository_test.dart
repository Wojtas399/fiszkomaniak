import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/repositories/flashcards_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_flashcards_service.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireFlashcardsService extends Mock implements FireFlashcardsService {}

void main() {
  final FireFlashcardsService fireFlashcardsService =
      MockFireFlashcardsService();
  late FlashcardsRepository repository;

  setUp(() {
    repository = FlashcardsRepository(
      fireFlashcardsService: fireFlashcardsService,
    );
  });

  tearDown(() {
    reset(fireFlashcardsService);
  });

  test('add flashcards', () async {
    final List<Flashcard> flashcards = [
      createFlashcard(
        groupId: 'g1',
        question: 'f1 question',
        answer: 'f1 answer',
        status: FlashcardStatus.notRemembered,
      ),
      createFlashcard(
        groupId: 'g1',
        question: 'f2 question',
        answer: 'f2 answer',
        status: FlashcardStatus.notRemembered,
      ),
    ];
    final List<FlashcardDbModel> convertedFlashcards = [
      FlashcardDbModel(
        groupId: flashcards[0].groupId,
        question: flashcards[0].question,
        answer: flashcards[0].answer,
        status: 'notRemembered',
      ),
      FlashcardDbModel(
        groupId: flashcards[1].groupId,
        question: flashcards[1].question,
        answer: flashcards[1].answer,
        status: 'notRemembered',
      ),
    ];
    when(() => fireFlashcardsService.addFlashcards(convertedFlashcards))
        .thenAnswer((_) async => '');

    await repository.addFlashcards(flashcards);

    verify(() => fireFlashcardsService.addFlashcards(convertedFlashcards))
        .called(1);
  });
}
