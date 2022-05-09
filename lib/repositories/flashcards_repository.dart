import 'dart:async';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_flashcards_service.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';

class FlashcardsRepository implements FlashcardsInterface {
  late final FireFlashcardsService _fireFlashcardsService;

  FlashcardsRepository({
    required FireFlashcardsService fireFlashcardsService,
  }) {
    _fireFlashcardsService = fireFlashcardsService;
  }

  @override
  Future<void> setFlashcards({
    required String groupId,
    required List<Flashcard> flashcards,
  }) async {
    await _fireFlashcardsService.setFlashcards(
      groupId,
      flashcards.map(_convertFlashcardToDbModel).toList(),
    );
  }

  @override
  Future<void> updateFlashcard({
    required String groupId,
    required Flashcard flashcard,
  }) async {
    await _fireFlashcardsService.updateFlashcard(
      groupId,
      _convertFlashcardToDbModel(flashcard),
    );
  }

  @override
  Future<void> removeFlashcard({
    required String groupId,
    required Flashcard flashcard,
  }) async {
    await _fireFlashcardsService.removeFlashcard(
      groupId,
      _convertFlashcardToDbModel(flashcard),
    );
  }

  FlashcardDbModel _convertFlashcardToDbModel(Flashcard flashcard) {
    return FlashcardDbModel(
      index: flashcard.index,
      question: flashcard.question,
      answer: flashcard.answer,
      status: _convertFlashcardStatusToString(flashcard.status),
    );
  }

  String _convertFlashcardStatusToString(FlashcardStatus status) {
    switch (status) {
      case FlashcardStatus.remembered:
        return 'remembered';
      case FlashcardStatus.notRemembered:
        return 'notRemembered';
    }
  }
}
