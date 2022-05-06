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
      await FireReferences.groupsRef.doc(groupId).update(
            GroupDbModel(flashcards: flashcards).toJson(),
          );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateFlashcard(
    String groupId,
    FlashcardDbModel flashcard,
  ) async {
    try {
      final group =
          await FireReferences.groupsRefWithConverter.doc(groupId).get();
      final List<FlashcardDbModel> flashcardsFromDb =
          group.data()?.flashcards ?? [];
      if (flashcardsFromDb.isNotEmpty) {
        flashcardsFromDb[flashcard.index] = flashcard.copyWith();
        await FireReferences.groupsRef.doc(groupId).update(
              GroupDbModel(flashcards: flashcardsFromDb).toJson(),
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
      await FireReferences.groupsRef.doc(groupId).update({
        'flashcards': FieldValue.arrayRemove([flashcard.toJson()]),
      });
    } catch (error) {
      rethrow;
    }
  }
}
