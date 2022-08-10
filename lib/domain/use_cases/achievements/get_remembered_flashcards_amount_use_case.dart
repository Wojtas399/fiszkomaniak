import 'package:rxdart/rxdart.dart';
import '../../../interfaces/achievements_interface.dart';

class GetRememberedFlashcardsAmountUseCase {
  late final AchievementsInterface _achievementsInterface;

  GetRememberedFlashcardsAmountUseCase({
    required AchievementsInterface achievementsInterface,
  }) {
    _achievementsInterface = achievementsInterface;
  }

  Stream<int> execute() {
    return _achievementsInterface.rememberedFlashcardsAmount.whereType<int>();
  }
}
