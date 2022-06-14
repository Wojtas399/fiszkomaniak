import 'dart:async';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_flashcards_service.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import '../firebase/services/fire_days_service.dart';

class FlashcardsRepository implements FlashcardsInterface {
  late final GroupsInterface _groupsInterface;
  late final FireFlashcardsService _fireFlashcardsService;
  late final FireDaysService _fireDaysService;

  FlashcardsRepository({
    required GroupsInterface groupsInterface,
    required FireFlashcardsService fireFlashcardsService,
    required FireDaysService fireDaysService,
  }) {
    _groupsInterface = groupsInterface;
    _fireFlashcardsService = fireFlashcardsService;
    _fireDaysService = fireDaysService;
  }

  @override
  Future<void> saveEditedFlashcards({
    required String groupId,
    required List<Flashcard> flashcards,
  }) async {
    await _fireFlashcardsService.setFlashcards(
      groupId,
      flashcards.map(_convertFlashcardToDbModel).toList(),
    );
  }

  @override
  Future<void> saveRememberedFlashcards({
    required String groupId,
    required List<int> flashcardsIndexes,
  }) async {
    await _fireDaysService.saveRememberedFlashcardsToCurrentDay(
      groupId: groupId,
      indexesOfRememberedFlashcards: flashcardsIndexes,
    );
    await _fireFlashcardsService.markFlashcardsAsRemembered(
      groupId: groupId,
      indexesOfRememberedFlashcards: flashcardsIndexes,
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

  @override
  Stream<List<Flashcard>> getFlashcardsFromGroup({required String groupId}) {
    return _groupsInterface
        .getGroupById(groupId: groupId)
        .map((group) => group.flashcards);
  }

  @override
  Stream<int> getAmountOfAllFlashcardsFromGroup({required String groupId}) {
    return getFlashcardsFromGroup(groupId: groupId)
        .map((flashcards) => flashcards.length);
  }

  @override
  Stream<int> getAmountOfRememberedFlashcardsFromGroup({
    required String groupId,
  }) {
    return getFlashcardsFromGroup(groupId: groupId)
        .map((flashcards) => flashcards.where(_isFlashcardRemembered))
        .map((rememberedFlashcards) => rememberedFlashcards.length);
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

  bool _isFlashcardRemembered(Flashcard flashcard) {
    return flashcard.status == FlashcardStatus.remembered;
  }
}
