import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/day_db_model.dart';
import 'package:fiszkomaniak/firebase/models/user_db_model.dart';
import 'package:fiszkomaniak/firebase/fire_converters.dart';
import '../models/day_flashcard_db_model.dart';

class FireDaysService {
  Future<Map<String, Object?>?> getUpdatedDays(
    List<DayFlashcardDbModel> flashcards,
  ) async {
    try {
      final userDoc = await FireReferences.loggedUserRefWithConverter.get();
      final UserDbModel? userData = userDoc.data();
      if (userData != null) {
        final List<DayDbModel>? days = userData.days;
        if (days != null) {
          final List<DayDbModel> updatedDays = _updateDays(days, flashcards);
          return userData.copyWith(days: updatedDays).toJson();
        } else {
          return userData.copyWith(
            days: [
              DayDbModel(
                date: FireConverters.convertDateTimeToString(DateTime.now()),
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

  List<DayDbModel> _updateDays(
    List<DayDbModel> existingDays,
    List<DayFlashcardDbModel> flashcardsToSave,
  ) {
    final List<DayDbModel> updatedDays = [...existingDays];
    final String currentDate = FireConverters.convertDateTimeToString(
      DateTime.now(),
    );
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
}
