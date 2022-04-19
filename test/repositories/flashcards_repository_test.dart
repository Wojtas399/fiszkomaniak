import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
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
      id: 'f1',
      groupId: 'g1',
      question: 'f1 question',
      answer: 'f1 answer',
      status: FlashcardStatus.notRemembered,
    ),
    createFlashcard(
      id: 'f2',
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

  setUp(() {
    repository = FlashcardsRepository(
      fireFlashcardsService: fireFlashcardsService,
    );
  });

  tearDown(() {
    reset(fireFlashcardsService);
  });

  test('add flashcards', () async {
    when(() => fireFlashcardsService.addFlashcards(convertedFlashcards))
        .thenAnswer((_) async => '');

    await repository.addFlashcards(flashcards);

    verify(() => fireFlashcardsService.addFlashcards(convertedFlashcards))
        .called(1);
  });

  test('update flashcards', () async {
    final List<FireDoc<FlashcardDbModel>> docsToSend = [
      FireDoc(id: flashcards[0].id, doc: convertedFlashcards[0]),
      FireDoc(id: flashcards[1].id, doc: convertedFlashcards[1]),
    ];
    when(() => fireFlashcardsService.updateFlashcards(docsToSend))
        .thenAnswer((_) async => '');

    await repository.updateFlashcards(flashcards);

    verify(() => fireFlashcardsService.updateFlashcards(docsToSend)).called(1);
  });

  test('remove flashcards', () async {
    final List<String> flashcardsIds =
        flashcards.map((flashcard) => flashcard.id).toList();
    when(() => fireFlashcardsService.removeFlashcards(flashcardsIds))
        .thenAnswer((_) async => '');

    await repository.removeFlashcards(flashcardsIds);

    verify(() => fireFlashcardsService.removeFlashcards(flashcardsIds))
        .called(1);
  });

  test('remove flashcards by groups ids', () async {
    final List<String> groupsIds = ['g1', 'g2'];
    when(() => fireFlashcardsService.removeFlashcardsByGroupsIds(groupsIds))
        .thenAnswer((_) async => '');

    await repository.removeFlashcardsByGroupsIds(groupsIds);

    verify(() => fireFlashcardsService.removeFlashcardsByGroupsIds(groupsIds))
        .called(1);
  });
}
