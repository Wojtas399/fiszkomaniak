import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import '../../entities/flashcard.dart';

class SaveEditedFlashcardsUseCase {
  late final GroupsInterface _groupsInterface;

  SaveEditedFlashcardsUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute({
    required String groupId,
    required List<Flashcard> flashcards,
  }) async {
    await _groupsInterface.saveEditedFlashcards(
      groupId: groupId,
      flashcards: flashcards,
    );
    //TODO: this use case should also save new flashcards to achievements
  }
}
