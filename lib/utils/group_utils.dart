import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import '../models/flashcard_model.dart';

class GroupUtils {
  static List<FlashcardsType> getAvailableFlashcardsTypeFromGroup(Group group) {
    final List<FlashcardsType> types = [FlashcardsType.all];
    final List<Flashcard> rememberedFlashcards = group.flashcards
        .where((flashcard) => flashcard.status == FlashcardStatus.remembered)
        .toList();
    if (rememberedFlashcards.isNotEmpty &&
        rememberedFlashcards.length < group.flashcards.length) {
      types.add(FlashcardsType.remembered);
      types.add(FlashcardsType.notRemembered);
    }
    return types;
  }
}