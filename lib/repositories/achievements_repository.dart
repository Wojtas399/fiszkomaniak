import 'package:fiszkomaniak/firebase/services/fire_achievements_service.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class AchievementsRepository implements AchievementsInterface {
  late final FireAchievementsService _fireAchievementsService;

  AchievementsRepository({
    required FireAchievementsService fireAchievementsService,
  }) {
    _fireAchievementsService = fireAchievementsService;
  }

  @override
  Future<void> initializeAchievements() async {
    await _fireAchievementsService.initializeAchievements();
  }

  @override
  Future<void> addNewFlashcards({
    required List<String> flashcardsIds,
    Function(int achievedConditionValue)? onAchievedNextCondition,
  }) async {
    final int? newAchievementValue =
        await _fireAchievementsService.updateAllFlashcardsAmount(flashcardsIds);
    if (newAchievementValue != null) {
      await _checkIfNextConditionHasBeenAchieved(
        achievementId: _fireAchievementsService.allFlashcardsAmountId,
        newAchievementValue: newAchievementValue,
        onAchievedNextCondition: onAchievedNextCondition,
      );
    }
  }

  @override
  Future<void> addNewRememberedFlashcards({
    required List<String> flashcardsIds,
    Function(int achievedConditionValue)? onAchievedNextCondition,
  }) async {
    final int? newAchievementValue = await _fireAchievementsService
        .updateRememberedFlashcardsAmount(flashcardsIds);
    if (newAchievementValue != null) {
      await _checkIfNextConditionHasBeenAchieved(
        achievementId: _fireAchievementsService.rememberedFlashcardsAmountId,
        newAchievementValue: newAchievementValue,
        onAchievedNextCondition: onAchievedNextCondition,
      );
    }
  }

  @override
  Future<void> addNewFinishedSession({
    required String? sessionId,
    Function(int achievedConditionValue)? onAchievedNextCondition,
  }) async {
    final int? completedSessionsAmount =
        await _fireAchievementsService.updateFinishedSessionsAmount(sessionId);
    if (completedSessionsAmount != null) {
      await _checkIfNextConditionHasBeenAchieved(
        achievementId: _fireAchievementsService.finishedSessionsAmountId,
        newAchievementValue: completedSessionsAmount,
        onAchievedNextCondition: onAchievedNextCondition,
      );
    }
  }

  Future<void> _checkIfNextConditionHasBeenAchieved({
    required String achievementId,
    required int newAchievementValue,
    required Function(int achievedConditionValue)? onAchievedNextCondition,
  }) async {
    final int? nextAchievedConditionValue =
        await _fireAchievementsService.getNextAchievedCondition(
      achievementType: achievementId,
      value: newAchievementValue,
    );
    if (nextAchievedConditionValue != null && onAchievedNextCondition != null) {
      onAchievedNextCondition(nextAchievedConditionValue);
    }
  }
}
