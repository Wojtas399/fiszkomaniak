import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';

import '../fire_instances.dart';

class FireFlashcardsService {
  Future<void> setFlashcards(
    String groupId,
    List<FlashcardDbModel> flashcards,
  ) async {
    try {
      await FireReferences.groupsRefWithConverter.doc(groupId).update(
            GroupDbModel(flashcards: flashcards).toJson(),
          );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> markFlashcardsAsRemembered({
    required String groupId,
    required List<int> indexesOfRememberedFlashcards,
  }) async {
    final batch = FireInstances.firestore.batch();
    final group =
        await FireReferences.groupsRefWithConverter.doc(groupId).get();
    final List<FlashcardDbModel> flashcardsFromGroup =
        group.data()?.flashcards ?? [];
    final List<FlashcardDbModel> updatedFlashcards = _updateFlashcardsStatuses(
      flashcardsFromGroup,
      indexesOfRememberedFlashcards,
    );
    batch.update(
      FireReferences.groupsRef.doc(groupId),
      GroupDbModel(flashcards: updatedFlashcards).toJson(),
    );
    await batch.commit();
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
      await FireReferences.groupsRefWithConverter.doc(groupId).update({
        'flashcards': FieldValue.arrayRemove([flashcard.toJson()]),
      });
    } catch (error) {
      rethrow;
    }
  }

  List<FlashcardDbModel> _updateFlashcardsStatuses(
    List<FlashcardDbModel> flashcards,
    List<int> indexesOfRememberedFlashcards,
  ) {
    return flashcards
        .map(
          (flashcard) => flashcard.copyWith(
            status: indexesOfRememberedFlashcards.contains(flashcard.index)
                ? 'remembered'
                : 'notRemembered',
          ),
        )
        .toList();
  }
}
