import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class UpdateFlashcardsStatusesUseCase {
  late final GroupsInterface _groupsInterface;

  UpdateFlashcardsStatusesUseCase({
    required GroupsInterface groupsInterface,
  }) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute({
    required String groupId,
    required List<int> indexesOfRememberedFlashcards,
  }) async {
    await _groupsInterface
        .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
      groupId: groupId,
      flashcardsIndexes: indexesOfRememberedFlashcards,
    );
    //TODO: should also update remembered flashcards amount in achievements
  }
}
