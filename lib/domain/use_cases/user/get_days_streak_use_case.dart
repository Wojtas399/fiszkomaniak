import 'package:rxdart/rxdart.dart';
import '../../../interfaces/user_interface.dart';

class GetDaysStreakUseCase {
  late final UserInterface _userInterface;

  GetDaysStreakUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Stream<int> execute() {
    return _userInterface.daysStreak$.whereType<int>();
  }
}
