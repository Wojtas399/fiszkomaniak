import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class RemoveFlashcardUseCase {
  late final GroupsInterface _groupsInterface;

  RemoveFlashcardUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute({
    required String groupId,
    required int flashcardIndex,
  }) async {
    await _groupsInterface.removeFlashcard(
      groupId: groupId,
      flashcardIndex: flashcardIndex,
    );
  }
}
