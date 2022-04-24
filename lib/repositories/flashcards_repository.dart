import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_flashcards_service.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import '../firebase/fire_utils.dart';

class FlashcardsRepository implements FlashcardsInterface {
  late final FireFlashcardsService _fireFlashcardsService;

  FlashcardsRepository({
    required FireFlashcardsService fireFlashcardsService,
  }) {
    _fireFlashcardsService = fireFlashcardsService;
  }

  @override
  Stream<List<ChangedDocument<Flashcard>>> getFlashcardsSnapshots() {
    return _fireFlashcardsService
        .getFlashcardsSnapshots()
        .map((snapshot) => snapshot.docChanges)
        .map(
          (docChanges) => docChanges
              .map(
                (element) => _convertFireDocumentToChangedDocumentModel(
                  element,
                ),
              )
              .whereType<ChangedDocument<Flashcard>>()
              .toList(),
        );
  }

  @override
  Future<void> addFlashcards(List<Flashcard> flashcards) async {
    await _fireFlashcardsService.addFlashcards(
      flashcards.map(_convertFlashcardToDbModel).toList(),
    );
  }

  @override
  Future<void> updateFlashcards(List<Flashcard> flashcards) async {
    await _fireFlashcardsService.updateFlashcards(
      flashcards
          .map(
            (flashcard) => FireDoc(
              id: flashcard.id,
              doc: _convertFlashcardToDbModel(flashcard),
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> removeFlashcards(List<String> idsOfFlashcards) async {
    await _fireFlashcardsService.removeFlashcards(idsOfFlashcards);
  }

  ChangedDocument<Flashcard>? _convertFireDocumentToChangedDocumentModel(
    DocumentChange<FlashcardDbModel> docChange,
  ) {
    final docData = docChange.doc.data();
    final String? groupId = docData?.groupId;
    final String? question = docData?.question;
    final String? answer = docData?.answer;
    final FlashcardStatus? status = _convertStringToFlashcardStatus(
      docData?.status,
    );
    if (groupId != null &&
        question != null &&
        answer != null &&
        status != null) {
      return ChangedDocument(
        changeType: FireUtils.convertChangeType(docChange.type),
        doc: Flashcard(
          id: docChange.doc.id,
          groupId: groupId,
          question: question,
          answer: answer,
          status: status,
        ),
      );
    }
    return null;
  }

  FlashcardDbModel _convertFlashcardToDbModel(Flashcard flashcard) {
    return FlashcardDbModel(
      groupId: flashcard.groupId,
      question: flashcard.question,
      answer: flashcard.answer,
      status: _convertFlashcardStatusToString(flashcard.status),
    );
  }

  FlashcardStatus? _convertStringToFlashcardStatus(String? value) {
    switch (value) {
      case 'remembered':
        return FlashcardStatus.remembered;
      case 'notRemembered':
        return FlashcardStatus.notRemembered;
      default:
        return null;
    }
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
