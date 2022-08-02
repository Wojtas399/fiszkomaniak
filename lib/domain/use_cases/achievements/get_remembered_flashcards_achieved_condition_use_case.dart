import '../../../interfaces/achievements_interface.dart';

class GetRememberedFlashcardsAchievedConditionUseCase {
  late final AchievementsInterface _achievementsInterface;

  GetRememberedFlashcardsAchievedConditionUseCase({
    required AchievementsInterface achievementsInterface,
  }) {
    _achievementsInterface = achievementsInterface;
  }

  Stream<int?> execute() {
    return _achievementsInterface.rememberedFlashcardsAchievedCondition$;
  }
}
