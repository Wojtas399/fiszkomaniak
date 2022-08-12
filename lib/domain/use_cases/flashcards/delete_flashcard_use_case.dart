import '../../../interfaces/groups_interface.dart';

class DeleteFlashcardUseCase {
  late final GroupsInterface _groupsInterface;

  DeleteFlashcardUseCase({required GroupsInterface groupsInterface}) {
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
