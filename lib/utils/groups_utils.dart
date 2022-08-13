import '../domain/entities/group.dart';
import '../domain/entities/session.dart';
import '../domain/entities/flashcard.dart';

class GroupsUtils {
  static List<FlashcardsType> getAvailableFlashcardsTypes(Group group) {
    final List<Flashcard> rememberedFlashcards = group.flashcards
        .where((flashcard) => flashcard.status == FlashcardStatus.remembered)
        .toList();
    if (rememberedFlashcards.isNotEmpty &&
        rememberedFlashcards.length < group.flashcards.length) {
      return FlashcardsType.values;
    }
    return [FlashcardsType.all];
  }

  static int getAmountOfRememberedFlashcards(Group group) {
    return group.flashcards
        .where(
          (Flashcard flashcard) =>
              flashcard.status == FlashcardStatus.remembered,
        )
        .length;
  }

  static List<Group> setGroupInAlphabeticalOrderByName(List<Group> groups) {
    final List<Group> sortedGroups = [...groups];
    sortedGroups.sort(_compareGroupsNames);
    return sortedGroups;
  }

  static int _compareGroupsNames(Group group1, Group group2) {
    return group1.name.toLowerCase().compareTo(group2.name.toLowerCase());
  }
}
