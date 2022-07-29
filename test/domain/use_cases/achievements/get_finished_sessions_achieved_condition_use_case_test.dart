import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/get_finished_sessions_achieved_condition_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final achievementsInterface = MockAchievementsInterface();
  final useCase = GetFinishedSessionsAchievedConditionUseCase(
    achievementsInterface: achievementsInterface,
  );

  test(
    'should return stream which contains value of the latest achieved condition of finished sessions amount',
    () async {
      when(
        () => achievementsInterface.finishedSessionsAchievedCondition$,
      ).thenAnswer((_) => Stream.value(10));

      final Stream<int?> finishedSessionsAchievedCondition$ = useCase.execute();

      expect(await finishedSessionsAchievedCondition$.first, 10);
    },
  );
}
