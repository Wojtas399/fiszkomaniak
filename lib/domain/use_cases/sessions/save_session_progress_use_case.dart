import '../../../interfaces/groups_interface.dart';
import '../../../interfaces/achievements_interface.dart';
import '../../../interfaces/user_interface.dart';
import '../../entities/flashcard.dart';

class SaveSessionProgressUseCase {
  late final GroupsInterface _groupsInterface;
  late final AchievementsInterface _achievementsInterface;
  late final UserInterface _userInterface;

  SaveSessionProgressUseCase({
    required GroupsInterface groupsInterface,
    required AchievementsInterface achievementsInterface,
    required UserInterface userInterface,
  }) {
    _groupsInterface = groupsInterface;
    _achievementsInterface = achievementsInterface;
    _userInterface = userInterface;
  }

  Future<void> execute({
    required String groupId,
    required List<Flashcard> rememberedFlashcards,
  }) async {
    await _groupsInterface
        .setGivenFlashcardsAsRememberedAndRemainingAsNotRemembered(
      groupId: groupId,
      flashcardsIndexes: _getIndexesOfFlashcards(rememberedFlashcards),
    );
    await _achievementsInterface.addRememberedFlashcards(
      groupId: groupId,
      rememberedFlashcards: rememberedFlashcards,
    );
    await _userInterface.addRememberedFlashcardsToCurrentDay(
      groupId: groupId,
      rememberedFlashcards: rememberedFlashcards,
    );
  }

  List<int> _getIndexesOfFlashcards(List<Flashcard> flashcards) {
    return flashcards.map((Flashcard flashcard) => flashcard.index).toList();
  }
}
