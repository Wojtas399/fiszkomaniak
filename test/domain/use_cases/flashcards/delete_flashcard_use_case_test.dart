import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/delete_flashcard_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = DeleteFlashcardUseCase(groupsInterface: groupsInterface);

  test(
    'should call method responsible for deleting flashcard',
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
