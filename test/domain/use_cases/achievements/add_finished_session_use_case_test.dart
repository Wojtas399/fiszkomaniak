import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/add_finished_session_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final achievementsInterface = MockAchievementsInterface();
  final useCase = AddFinishedSessionUseCase(
    achievementsInterface: achievementsInterface,
  );

  test(
    'should call method responsible for adding finished session to achievements',
    () async {
      const String sessionId = 's1';
      when(
        () => achievementsInterface.addFinishedSession(sessionId: sessionId),
      ).thenAnswer((_) async => '');

      await useCase.execute(sessionId: sessionId);

      verify(
        () => achievementsInterface.addFinishedSession(sessionId: sessionId),
      ).called(1);
    },
  );
}
