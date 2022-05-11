import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_instances.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/models/user_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_days_service.dart';
import '../models/day_flashcard_db_model.dart';
import '../models/flashcard_db_model.dart';

class FireUserService {
  final FireDaysService _fireDaysService = FireDaysService();

  Stream<DocumentSnapshot<UserDbModel>> getLoggedUserSnapshots() {
    return FireReferences.loggedUserRefWithConverter.snapshots();
  }

  Future<void> addUser(String userId, String username) async {
    try {
      await FireReferences.usersRef
          .doc(userId)
          .set(UserDbModel(username: username));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveNewUsername(String newUsername) async {
    try {
      await FireReferences.loggedUserRef.update(
        UserDbModel(username: newUsername).toJson(),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveNewRememberedFlashcards(
    String groupId,
    List<int> indexesOfRememberedFlashcards,
  ) async {
    try {
      final batch = FireInstances.firestore.batch();
      final List<DayFlashcardDbModel> daysFlashcards = _createDaysFlashcards(
        groupId,
        indexesOfRememberedFlashcards,
      );
      final Map<String, Object?>? updatedDays =
          await _fireDaysService.getUpdatedDays(daysFlashcards);
      final group =
          await FireReferences.groupsRefWithConverter.doc(groupId).get();
      final List<FlashcardDbModel> flashcardsFromGroup =
          group.data()?.flashcards ?? [];
      final List<FlashcardDbModel> updatedFlashcards =
          _updateFlashcardsStatuses(
        flashcardsFromGroup,
        indexesOfRememberedFlashcards,
      );
      if (updatedDays != null) {
        batch.set(FireReferences.loggedUserRef, updatedDays);
      }
      batch.update(
        FireReferences.groupsRef.doc(groupId),
        GroupDbModel(flashcards: updatedFlashcards).toJson(),
      );
      await batch.commit();
    } catch (error) {
      rethrow;
    }
  }

  List<DayFlashcardDbModel> _createDaysFlashcards(
    String groupId,
    List<int> indexesOfRememberedFlashcards,
  ) {
    return indexesOfRememberedFlashcards
        .map(
          (index) => DayFlashcardDbModel(
            groupId: groupId,
            flashcardIndex: index,
          ),
        )
        .toList();
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
