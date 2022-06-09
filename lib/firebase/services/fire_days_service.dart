import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/day_db_model.dart';
import 'package:fiszkomaniak/firebase/models/user_db_model.dart';
import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import '../fire_instances.dart';
import '../models/day_flashcard_db_model.dart';

class FireDaysService {
  Future<void> saveRememberedFlashcardsToCurrentDay({
    required String groupId,
    required List<int> indexesOfRememberedFlashcards,
  }) async {
    final batch = FireInstances.firestore.batch();
    final List<DayFlashcardDbModel> flashcards = _createDayFlashcards(
      groupId,
      indexesOfRememberedFlashcards,
    );
    final updatedDays = await _getUpdatedDaysWithNewFlashcards(flashcards);
    if (updatedDays != null) {
      batch.set(FireReferences.loggedUserRef, updatedDays);
    }
    await batch.commit();
  }

  Future<Map<String, Object?>?> _getUpdatedDaysWithNewFlashcards(
    List<DayFlashcardDbModel> flashcards,
  ) async {
    try {
      final userDoc = await FireReferences.loggedUserRefWithConverter.get();
      final UserDbModel? userData = userDoc.data();
      if (userData != null) {
        final List<DayDbModel>? days = userData.days;
        if (days != null) {
          final List<DayDbModel> updatedDays = _addFlashcardsToCurrentDay(
            days,
            flashcards,
          );
          return userData.copyWith(days: updatedDays).toJson();
        } else {
          return userData.copyWith(
            days: [
              DayDbModel(
                date: Date.now().toDbString(),
                rememberedFlashcards: flashcards,
              )
            ],
          ).toJson();
        }
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  List<DayDbModel> _addFlashcardsToCurrentDay(
    List<DayDbModel> existingDays,
    List<DayFlashcardDbModel> flashcardsToSave,
  ) {
    final List<DayDbModel> updatedDays = [...existingDays];
    final String currentDate = Date.now().toDbString();
    final DayDbModel latestDay = updatedDays.last;
    if (latestDay.date == currentDate) {
      final List<DayFlashcardDbModel> rememberedFlashcards = [
        ...latestDay.rememberedFlashcards,
      ];
      for (final flashcard in flashcardsToSave) {
        if (!rememberedFlashcards.contains(flashcard)) {
          rememberedFlashcards.add(flashcard);
        }
      }
      updatedDays[updatedDays.length - 1] = latestDay.copyWith(
        rememberedFlashcards: rememberedFlashcards,
      );
    } else {
      updatedDays.add(DayDbModel(
        date: currentDate,
        rememberedFlashcards: flashcardsToSave,
      ));
    }
    return updatedDays;
  }

  List<DayFlashcardDbModel> _createDayFlashcards(
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
}
