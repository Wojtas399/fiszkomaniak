import 'package:fiszkomaniak/domain/use_cases/flashcards/remove_flashcard_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = RemoveFlashcardUseCase(groupsInterface: groupsInterface);

  test(
    'should call method responsible for removing flashcard',
    () async {
      when(
        () => groupsInterface.removeFlashcard(
          groupId: 'g1',
          flashcardIndex: 0,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(groupId: 'g1', flashcardIndex: 0);

      verify(
        () => groupsInterface.removeFlashcard(
          groupId: 'g1',
          flashcardIndex: 0,
        ),
      ).called(1);
    },
  );
}
