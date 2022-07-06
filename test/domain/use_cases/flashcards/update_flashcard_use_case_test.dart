import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcard_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = UpdateFlashcardUseCase(groupsInterface: groupsInterface);

  test(
    'should call method responsible from updating flashcard',
    () async {
      final Flashcard flashcard = createFlashcard(
        index: 0,
        question: 'q0',
        answer: 'a0',
      );
      when(
        () => groupsInterface.updateFlashcard(
          groupId: 'g1',
          flashcard: flashcard,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(groupId: 'g1', flashcard: flashcard);

      verify(
        () => groupsInterface.updateFlashcard(
          groupId: 'g1',
          flashcard: flashcard,
        ),
      ).called(1);
    },
  );
}
