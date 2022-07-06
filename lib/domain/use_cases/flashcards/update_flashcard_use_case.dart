import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class UpdateFlashcardUseCase {
  late final GroupsInterface _groupsInterface;

  UpdateFlashcardUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute({
    required String groupId,
    required Flashcard flashcard,
  }) async {
    await _groupsInterface.updateFlashcard(
      groupId: groupId,
      flashcard: flashcard,
    );
  }
}
