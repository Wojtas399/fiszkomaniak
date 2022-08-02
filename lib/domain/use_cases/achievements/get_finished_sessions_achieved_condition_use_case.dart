import '../../../interfaces/achievements_interface.dart';

class GetFinishedSessionsAchievedConditionUseCase {
  late final AchievementsInterface _achievementsInterface;

  GetFinishedSessionsAchievedConditionUseCase({
    required AchievementsInterface achievementsInterface,
  }) {
    _achievementsInterface = achievementsInterface;
  }

  Stream<int?> execute() {
    return _achievementsInterface.finishedSessionsAchievedCondition$;
  }
}
