import 'package:cloud_firestore/cloud_firestore.dart';
import '../fire_document.dart';
import '../fire_references.dart';
import '../fire_utils.dart';
import '../models/flashcard_db_model.dart';
import '../models/group_db_model.dart';

class FireFlashcardsService {
  Future<FireDocument<GroupDbModel>?> setFlashcards(
    String groupId,
    List<FlashcardDbModel> flashcards,
  ) async {
    final groupRef = FireReferences.groupsRefWithConverter.doc(groupId);
    await groupRef.update(GroupDbModel(flashcards: flashcards).toJson());
    final group = await groupRef.get();
    return _convertDocumentSnapshotToFireDocument(group);
  }

  Future<FireDocument<GroupDbModel>?>
      setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered({
    required String groupId,
    required List<int> indexesOfRememberedFlashcards,
  }) async {
    final groupRef = FireReferences.groupsRefWithConverter.doc(groupId);
    var group = await groupRef.get();
    final flashcardsFromGroup = group.data()?.flashcards ?? [];
    final List<FlashcardDbModel> updatedFlashcards = _updateFlashcardsStatuses(
      flashcardsFromGroup,
      indexesOfRememberedFlashcards,
    );
    await groupRef.update(GroupDbModel(flashcards: updatedFlashcards).toJson());
    group = await groupRef.get();
    return _convertDocumentSnapshotToFireDocument(group);
  }

  Future<FireDocument<GroupDbModel>?> updateFlashcard(
    String groupId,
    FlashcardDbModel flashcard,
  ) async {
    final groupRef = FireReferences.groupsRefWithConverter.doc(groupId);
    var group = await groupRef.get();
    final flashcardsFromDb = group.data()?.flashcards ?? [];
    if (flashcardsFromDb.isNotEmpty) {
      flashcardsFromDb[flashcard.index] = flashcard.copyWith();
      await groupRef
          .update(GroupDbModel(flashcards: flashcardsFromDb).toJson());
      group = await groupRef.get();
      return _convertDocumentSnapshotToFireDocument(group);
    }
    return null;
  }

  Future<FireDocument<GroupDbModel>?> removeFlashcard(
    String groupId,
    int flashcardIndex,
  ) async {
    final groupRef = FireReferences.groupsRefWithConverter.doc(groupId);
    var group = await groupRef.get();
    final flashcards = group.data()?.flashcards ?? [];
    final flashcardToRemove = flashcards[flashcardIndex];
    await groupRef.update({
      'flashcards': FieldValue.arrayRemove([flashcardToRemove.toJson()]),
    });
    group = await groupRef.get();
    return _convertDocumentSnapshotToFireDocument(group);
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

  FireDocument<GroupDbModel>? _convertDocumentSnapshotToFireDocument(
    DocumentSnapshot<GroupDbModel> doc,
  ) {
    return FireUtils.convertDocumentSnapshotToFireDocument<GroupDbModel>(doc);
  }
}
