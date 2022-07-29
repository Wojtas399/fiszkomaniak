import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcards_statuses_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final achievementsInterface = MockAchievementsInterface();
  final useCase = UpdateFlashcardsStatusesUseCase(
    groupsInterface: groupsInterface,
    achievementsInterface: achievementsInterface,
  );

  test(
    'should call method responsible for setting given flashcards as remembered and remaining as not remembered and method responsible for adding remembered flashcards to achievements',
    () async {
      const String groupId = 'g1';
      final List<Flashcard> rememberedFlashcards = [
        createFlashcard(index: 0),
        createFlashcard(index: 2),
        createFlashcard(index: 4),
      ];
      final List<int> flashcardsIndexes = rememberedFlashcards
          .map((Flashcard flashcard) => flashcard.index)
          .toList();
      when(
        () => groupsInterface
            .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
          groupId: groupId,
          flashcardsIndexes: flashcardsIndexes,
        ),
      ).thenAnswer((_) async => '');
      when(
        () => achievementsInterface.addRememberedFlashcards(
          groupId: groupId,
          rememberedFlashcards: rememberedFlashcards,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        groupId: groupId,
        rememberedFlashcards: rememberedFlashcards,
      );

      verify(
        () => groupsInterface
            .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
          groupId: groupId,
          flashcardsIndexes: flashcardsIndexes,
        ),
      ).called(1);
      verify(
        () => achievementsInterface.addRememberedFlashcards(
          groupId: groupId,
          rememberedFlashcards: rememberedFlashcards,
        ),
      ).called(1);
    },
  );
}
