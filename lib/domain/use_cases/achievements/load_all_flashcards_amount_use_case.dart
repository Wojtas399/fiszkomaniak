import '../../../interfaces/achievements_interface.dart';

class LoadAllFlashcardsAmountUseCase {
  late final AchievementsInterface _achievementsInterface;

  LoadAllFlashcardsAmountUseCase({
    required AchievementsInterface achievementsInterface,
  }) {
    _achievementsInterface = achievementsInterface;
  }

  Future<void> execute() async {
    await _achievementsInterface.loadAllFlashcardsAmount();
  }
}
