import '../../../interfaces/achievements_interface.dart';

class LoadRememberedFlashcardsAmountUseCase {
  late final AchievementsInterface _achievementsInterface;

  LoadRememberedFlashcardsAmountUseCase({
    required AchievementsInterface achievementsInterface,
  }) {
    _achievementsInterface = achievementsInterface;
  }

  Future<void> execute() async {
    await _achievementsInterface.loadRememberedFlashcardsAmount();
  }
}
