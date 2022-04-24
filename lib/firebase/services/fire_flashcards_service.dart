import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import '../fire_instances.dart';

class FireFlashcardsService {
  static Future<QuerySnapshot<FlashcardDbModel>> getFlashcardsByGroupsIds(
    List<String> groupsIds,
  ) async {
    return await FireReferences.flashcardsRef
        .where('groupId', whereIn: groupsIds)
        .get();
  }

  Stream<QuerySnapshot<FlashcardDbModel>> getFlashcardsSnapshots() {
    return FireReferences.flashcardsRef.snapshots();
  }

  Future<void> addFlashcards(List<FlashcardDbModel> flashcards) async {
    try {
      final batch = FireInstances.firestore.batch();
      for (final flashcard in flashcards) {
        final docRef = FireReferences.flashcardsRef.doc();
        batch.set(docRef, flashcard);
      }
      batch.commit();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateFlashcards(
    List<FireDoc<FlashcardDbModel>> flashcards,
  ) async {
    try {
      final batch = FireInstances.firestore.batch();
      for (final flashcard in flashcards) {
        final docRef = FireReferences.flashcardsRef.doc(
          flashcard.id,
        );
        batch.update(docRef, flashcard.doc.toJson());
      }
      batch.commit();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeFlashcards(List<String> idsOfFlashcardsToRemove) async {
    try {
      final batch = FireInstances.firestore.batch();
      for (final id in idsOfFlashcardsToRemove) {
        final docRef = FireReferences.flashcardsRef.doc(id);
        batch.delete(docRef);
      }
      batch.commit();
    } catch (error) {
      rethrow;
    }
  }
}
