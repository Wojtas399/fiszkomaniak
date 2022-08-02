import '../domain/entities/flashcard.dart';

abstract class AchievementsInterface {
  Stream<int?> get allFlashcardsAmount$;

  Stream<int?> get allFlashcardsAchievedCondition$;

  Stream<int?> get rememberedFlashcardsAchievedCondition$;

  Stream<int?> get finishedSessionsAchievedCondition$;

  Future<void> loadAllFlashcardsAmount();

  Future<void> setInitialAchievements();

  Future<void> addFlashcards({
    required String groupId,
    required List<Flashcard> flashcards,
  });

  Future<void> addRememberedFlashcards({
    required String groupId,
    required List<Flashcard> rememberedFlashcards,
  });

  Future<void> addFinishedSession({
    required String? sessionId,
  });

  void reset();
}
