import '../../../interfaces/groups_interface.dart';
import '../../../interfaces/achievements_interface.dart';
import '../../entities/flashcard.dart';

class SaveEditedFlashcardsUseCase {
  late final GroupsInterface _groupsInterface;
  late final AchievementsInterface _achievementsInterface;

  SaveEditedFlashcardsUseCase({
    required GroupsInterface groupsInterface,
    required AchievementsInterface achievementsInterface,
  }) {
    _groupsInterface = groupsInterface;
    _achievementsInterface = achievementsInterface;
  }

  Future<void> execute({
    required String groupId,
    required List<Flashcard> flashcards,
  }) async {
    await _groupsInterface.saveEditedFlashcards(
      groupId: groupId,
      flashcards: flashcards,
    );
    await _achievementsInterface.addFlashcards(
      groupId: groupId,
      flashcards: flashcards,
    );
  }
}
