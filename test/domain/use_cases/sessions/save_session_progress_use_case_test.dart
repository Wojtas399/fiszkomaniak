import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/save_session_progress_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final achievementsInterface = MockAchievementsInterface();
  final userInterface = MockUserInterface();
  final useCase = SaveSessionProgressUseCase(
    groupsInterface: groupsInterface,
    achievementsInterface: achievementsInterface,
    userInterface: userInterface,
  );

  test(
    'should call method responsible for setting given flashcards as remembered and remaining as not remembered, method responsible for adding remembered flashcards to achievements and method responsible for adding remembered flashcards to current day',
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
      when(
        () => userInterface.addRememberedFlashcardsToCurrentDay(
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
      verify(
        () => userInterface.addRememberedFlashcardsToCurrentDay(
          groupId: groupId,
          rememberedFlashcards: rememberedFlashcards,
        ),
      ).called(1);
    },
  );
}
