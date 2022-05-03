import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';

class FireFlashcardsService {
  Future<void> setFlashcards(
    String groupId,
    List<FlashcardDbModel> flashcards,
  ) async {
    try {
      await FireReferences.groupsReference.doc(groupId).update({
        'flashcards':
            flashcards.map((flashcard) => flashcard.toJson()).toList(),
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateFlashcard(
    String groupId,
    FlashcardDbModel flashcard,
  ) async {
    try {
      final group = await FireReferences.groupsReference.doc(groupId).get();
      final List<FlashcardDbModel> flashcardsFromDb =
          group.data()?.flashcards ?? [];
      if (flashcardsFromDb.isNotEmpty) {
        flashcardsFromDb[flashcard.index] = flashcard;
        await FireReferences.groupsReference.doc(groupId).update(
              GroupDbModel(
                name: null,
                courseId: null,
                nameForQuestions: null,
                nameForAnswers: null,
                flashcards: flashcardsFromDb,
              ).toJson(),
            );
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeFlashcard(
    String groupId,
    FlashcardDbModel flashcard,
  ) async {
    try {
      await FireReferences.groupsReference.doc(groupId).update({
        'flashcards': FieldValue.arrayRemove([flashcard.toJson()]),
      });
    } catch (error) {
      rethrow;
    }
  }
}
