import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/load_remembered_flashcards_amount_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final achievementsInterface = MockAchievementsInterface();
  final useCase = LoadRememberedFlashcardsAmountUseCase(
    achievementsInterface: achievementsInterface,
  );

  test(
    'should call method responsible for loading remembered flashcards amount',
    () async {
      when(
        () => achievementsInterface.loadRememberedFlashcardsAmount(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => achievementsInterface.loadRememberedFlashcardsAmount(),
      ).called(1);
    },
  );
}
