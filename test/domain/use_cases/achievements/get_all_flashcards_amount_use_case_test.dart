import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/get_all_flashcards_amount_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final achievementsInterface = MockAchievementsInterface();
  final useCase = GetAllFlashcardsAmountUseCase(
    achievementsInterface: achievementsInterface,
  );

  test(
    'should return stream which contains amount of all flashcards',
    () async {
      when(
        () => achievementsInterface.allFlashcardsAmount$,
      ).thenAnswer((_) => Stream.value(200));

      final Stream<int?> allFlashcardsAmount$ = useCase.execute();

      expect(await allFlashcardsAmount$.first, 200);
    },
  );
}
