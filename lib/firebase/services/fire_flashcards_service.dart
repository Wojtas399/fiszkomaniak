import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import '../fire_instances.dart';
import '../fire_user.dart';

class FireFlashcardsService {
  Stream<QuerySnapshot<FlashcardDbModel>> getFlashcardsSnapshots() {
    final String? loggedUserId = FireUser.getLoggedUserId();
    if (loggedUserId != null) {
      return _getFlashcardsRef(loggedUserId).snapshots();
    } else {
      throw FireUser.noLoggedUserMessage;
    }
  }

  Future<void> addFlashcards(List<FlashcardDbModel> flashcards) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        final batch = FireInstances.firestore.batch();
        for (final flashcard in flashcards) {
          final docRef = _getFlashcardsRef(loggedUserId).doc();
          batch.set(docRef, flashcard);
        }
        batch.commit();
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateFlashcards(
    List<FireDoc<FlashcardDbModel>> flashcards,
  ) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        final batch = FireInstances.firestore.batch();
        for (final flashcard in flashcards) {
          final docRef = _getFlashcardsRef(loggedUserId).doc(flashcard.id);
          batch.update(docRef, flashcard.doc.toJson());
        }
        batch.commit();
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeFlashcards(List<String> idsOfFlashcardsToRemove) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        final batch = FireInstances.firestore.batch();
        for (final id in idsOfFlashcardsToRemove) {
          final docRef = _getFlashcardsRef(loggedUserId).doc(id);
          batch.delete(docRef);
        }
        batch.commit();
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<FlashcardDbModel> _getFlashcardsRef(
    String userId,
  ) {
    return FireInstances.firestore
        .collection('Users')
        .doc(userId)
        .collection('Flashcards')
        .withConverter<FlashcardDbModel>(
          fromFirestore: (snapshot, _) => FlashcardDbModel.fromJson(
            snapshot.data()!,
          ),
          toFirestore: (data, _) => data.toJson(),
        );
  }
}
