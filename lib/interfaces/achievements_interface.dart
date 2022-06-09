abstract class AchievementsInterface {
  Future<void> initializeAchievements();

  Future<void> addNewFlashcards({
    required List<String> flashcardsIds,
    Function(int achievedConditionValue)? onAchievedNextCondition,
  });

  Future<void> addNewRememberedFlashcards({
    required List<String> flashcardsIds,
    Function(int achievedConditionValue)? onAchievedNextCondition,
  });

  Future<void> addNewFinishedSession({
    required String? sessionId,
    Function(int achievedConditionValue)? onAchievedNextCondition,
  });
}
