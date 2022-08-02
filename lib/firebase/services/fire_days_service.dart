import '../../models/date_model.dart';
import '../models/day_db_model.dart';
import '../fire_references.dart';
import '../fire_extensions.dart';

class FireDaysService {
  Future<List<DayDbModel>?> saveRememberedFlashcardsToCurrentDay({
    required List<String> flashcardsIds,
  }) async {
    final loggedUserRef = FireReferences.loggedUserRefWithConverter;
    final userDoc = await loggedUserRef.get();
    final userData = userDoc.data();
    if (userData != null) {
      final updatedDays = _getUpdatedDaysWithNewFlashcards(
        userData.days,
        flashcardsIds,
      );
      await loggedUserRef.update(
        userData.copyWith(days: updatedDays).toJson(),
      );
      return updatedDays;
    }
    return null;
  }

  List<DayDbModel>? _getUpdatedDaysWithNewFlashcards(
    List<DayDbModel>? existingDays,
    List<String> flashcardsIds,
  ) {
    if (existingDays != null) {
      return _addFlashcardsToCurrentDay(existingDays, flashcardsIds);
    } else {
      return [
        DayDbModel(
          date: Date.now().toDbString(),
          rememberedFlashcardsIds: flashcardsIds,
        ),
      ];
    }
  }

  List<DayDbModel> _addFlashcardsToCurrentDay(
    List<DayDbModel> existingDays,
    List<String> flashcardsToSaveIds,
  ) {
    final List<DayDbModel> updatedDays = [...existingDays];
    final String currentDate = Date.now().toDbString();
    final DayDbModel latestDay = updatedDays.last;
    if (latestDay.date == currentDate) {
      List<String> rememberedFlashcardsIds = [
        ...latestDay.rememberedFlashcardsIds,
      ];
      rememberedFlashcardsIds.addAll(flashcardsToSaveIds);
      rememberedFlashcardsIds = rememberedFlashcardsIds.toSet().toList();
      updatedDays[updatedDays.length - 1] = latestDay.copyWith(
        rememberedFlashcardsIds: rememberedFlashcardsIds,
      );
    } else {
      updatedDays.add(DayDbModel(
        date: currentDate,
        rememberedFlashcardsIds: flashcardsToSaveIds,
      ));
    }
    return updatedDays;
  }
}
