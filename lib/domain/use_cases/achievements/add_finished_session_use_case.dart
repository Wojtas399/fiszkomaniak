import '../../../interfaces/achievements_interface.dart';

class AddFinishedSessionUseCase {
  late final AchievementsInterface _achievementsInterface;

  AddFinishedSessionUseCase({
    required AchievementsInterface achievementsInterface,
  }) {
    _achievementsInterface = achievementsInterface;
  }

  Future<void> execute({required String? sessionId}) async {
    await _achievementsInterface.addFinishedSession(sessionId: sessionId);
  }
}
