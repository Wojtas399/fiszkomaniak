import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/save_edited_flashcards_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = SaveEditedFlashcardsUseCase(groupsInterface: groupsInterface);

  test(
    'should call method responsible for saving edited flashcards in group',
    () async {
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0, question: 'q0', answer: 'a0'),
        createFlashcard(index: 1, question: 'q1', answer: 'a1'),
      ];
      when(
        () => groupsInterface.saveEditedFlashcards(
          groupId: 'g1',
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
    },
  );
}
