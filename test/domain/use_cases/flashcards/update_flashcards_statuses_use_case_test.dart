import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcards_statuses_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = UpdateFlashcardsStatusesUseCase(
    groupsInterface: groupsInterface,
  );

  test(
    'should call method responsible for setting given flashcards as remembered and remaining as not remembered',
    () async {
      when(
        () => groupsInterface
            .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
          groupId: 'g1',
          flashcardsIndexes: [1, 2],
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        groupId: 'g1',
        indexesOfRememberedFlashcards: [1, 2],
      );

      verify(
        () => groupsInterface
            .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
          groupId: 'g1',
          flashcardsIndexes: [1, 2],
        ),
      ).called(1);
    },
  );
}
