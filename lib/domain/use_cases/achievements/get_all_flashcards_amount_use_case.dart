import 'package:rxdart/rxdart.dart';
import '../../../interfaces/achievements_interface.dart';

class GetAllFlashcardsAmountUseCase {
  late final AchievementsInterface _achievementsInterface;

  GetAllFlashcardsAmountUseCase({
    required AchievementsInterface achievementsInterface,
  }) {
    _achievementsInterface = achievementsInterface;
  }

  Stream<int> execute() {
    return _achievementsInterface.allFlashcardsAmount$.whereType<int>();
  }
}
