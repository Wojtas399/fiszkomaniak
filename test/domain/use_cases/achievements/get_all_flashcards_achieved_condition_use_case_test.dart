import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/get_all_flashcards_achieved_condition_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final achievementsInterface = MockAchievementsInterface();
  final useCase = GetAllFlashcardsAchievedConditionUseCase(
    achievementsInterface: achievementsInterface,
  );

  test(
    'should return stream which contains value of the latest achieved condition of all flashcards amount',
    () async {
      when(
        () => achievementsInterface.allFlashcardsAchievedCondition$,
      ).thenAnswer((_) => Stream.value(100));

      final Stream<int?> allFlashcardsAchievedCondition$ = useCase.execute();

      expect(await allFlashcardsAchievedCondition$.first, 100);
    },
  );
}
