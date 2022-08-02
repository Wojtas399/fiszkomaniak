import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/get_remembered_flashcards_achieved_condition_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final achievementsInterface = MockAchievementsInterface();
  final useCase = GetRememberedFlashcardsAchievedConditionUseCase(
    achievementsInterface: achievementsInterface,
  );

  test(
    'should return stream which contains value of the latest achieved condition of remembered flashcards amount',
    () async {
      when(
        () => achievementsInterface.rememberedFlashcardsAchievedCondition$,
      ).thenAnswer((_) => Stream.value(100));

      final Stream<int?> rememberedFlashcardsAchievedCondition$ =
          useCase.execute();

      expect(await rememberedFlashcardsAchievedCondition$.first, 100);
    },
  );
}
