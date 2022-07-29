import '../../../interfaces/achievements_interface.dart';

class GetAllFlashcardsAchievedConditionUseCase {
  late final AchievementsInterface _achievementsInterface;

  GetAllFlashcardsAchievedConditionUseCase({
    required AchievementsInterface achievementsInterface,
  }) {
    _achievementsInterface = achievementsInterface;
  }

  Stream<int?> execute() {
    return _achievementsInterface.allFlashcardsAchievedCondition$;
  }
}
