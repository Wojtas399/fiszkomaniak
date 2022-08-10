import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/get_remembered_flashcards_amount_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final achievementsInterface = MockAchievementsInterface();
  final useCase = GetRememberedFlashcardsAmountUseCase(
    achievementsInterface: achievementsInterface,
  );

  test(
    'should return stream which contains amount of remembered flashcards',
    () async {
      when(
        () => achievementsInterface.rememberedFlashcardsAmount,
      ).thenAnswer((_) => Stream.value(200));

      final Stream<int?> rememberedFlashcardsAmount$ = useCase.execute();

      expect(await rememberedFlashcardsAmount$.first, 200);
    },
  );
}
