import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/save_edited_flashcards_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final achievementsInterface = MockAchievementsInterface();
  final useCase = SaveEditedFlashcardsUseCase(
    groupsInterface: groupsInterface,
    achievementsInterface: achievementsInterface,
  );

  test(
    'should call method responsible for saving edited flashcards in group and for adding flashcards to achievements',
    () async {
      const String groupId = 'g1';
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0, question: 'q0', answer: 'a0'),
        createFlashcard(index: 1, question: 'q1', answer: 'a1'),
      ];
      when(
        () => groupsInterface.saveEditedFlashcards(
          groupId: groupId,
          flashcards: flashcards,
        ),
      ).thenAnswer((_) async => '');
      when(
        () => achievementsInterface.addFlashcards(
          groupId: groupId,
          flashcards: flashcards,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(groupId: 'g1', flashcards: flashcards);

      verify(
        () => groupsInterface.saveEditedFlashcards(
          groupId: 'g1',
          flashcards: flashcards,
        ),
      ).called(1);
      verify(
        () => achievementsInterface.addFlashcards(
          groupId: groupId,
          flashcards: flashcards,
        ),
      ).called(1);
    },
  );
}
