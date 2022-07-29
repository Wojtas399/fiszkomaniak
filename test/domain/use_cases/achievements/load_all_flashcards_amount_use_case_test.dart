import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/load_all_flashcards_amount_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final achievementsInterface = MockAchievementsInterface();
  final useCase = LoadAllFlashcardsAmountUseCase(
    achievementsInterface: achievementsInterface,
  );

  test(
    'should call method responsible for loading all flashcards amount',
    () async {
      when(
        () => achievementsInterface.loadAllFlashcardsAmount(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => achievementsInterface.loadAllFlashcardsAmount(),
      ).called(1);
    },
  );
}
