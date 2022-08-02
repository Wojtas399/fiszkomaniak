import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import '../domain/entities/flashcard.dart';

class GroupUtils {
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
}
