import 'package:rxdart/rxdart.dart';
import '../../firebase/models/achievement_db_model.dart';
import '../../firebase/services/fire_achievements_service.dart';
import '../../interfaces/achievements_interface.dart';
import '../entities/flashcard.dart';

class AchievementsRepository implements AchievementsInterface {
  late final FireAchievementsService _fireAchievementsService;
  final BehaviorSubject<int?> _allFlashcardsAmount$ =
      BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<int?> _allFlashcardsAchievedCondition$ =
      BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<int?> _rememberedFlashcardsAchievedCondition$ =
      BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<int?> _finishedSessionsAchievedCondition$ =
      BehaviorSubject<int?>.seeded(null);

  AchievementsRepository({
    required FireAchievementsService fireAchievementsService,
  }) {
    _fireAchievementsService = fireAchievementsService;
  }

  @override
  Stream<int?> get allFlashcardsAmount$ => _allFlashcardsAmount$.stream;

  @override
  Stream<int?> get allFlashcardsAchievedCondition$ =>
      _allFlashcardsAchievedCondition$.stream;

  @override
  Stream<int?> get rememberedFlashcardsAchievedCondition$ =>
      _rememberedFlashcardsAchievedCondition$.stream;

  @override
  Stream<int?> get finishedSessionsAchievedCondition$ =>
      _finishedSessionsAchievedCondition$.stream;

  @override
  Future<void> loadAllFlashcardsAmount() async {
    final AchievementDbModel? allFlashcardsAmount =
        await _fireAchievementsService.loadAllFlashcardsAmount();
    if (allFlashcardsAmount != null) {
      _allFlashcardsAmount$.add(
        allFlashcardsAmount.completedElementsIds?.length ?? 0,
      );
    }
  }

  @override
  Future<void> setInitialAchievements() async {
    await _fireAchievementsService.initializeAchievements();
  }

  @override
  Future<void> addFlashcards({
    required String groupId,
    required List<Flashcard> flashcards,
  }) async {
    final List<String> flashcardsIds = _getFlashcardsIds(groupId, flashcards);
    final int? newAchievementValue =
        await _fireAchievementsService.updateAllFlashcardsAmount(flashcardsIds);
    if (newAchievementValue != null) {
      _allFlashcardsAmount$.add(newAchievementValue);
      await _checkAllFlashcardsAchievedConditionValue(
        newAchievementValue,
      );
    }
  }

  @override
  Future<void> addRememberedFlashcards({
    required String groupId,
    required List<Flashcard> rememberedFlashcards,
  }) async {
    final List<String> flashcardsIds = _getFlashcardsIds(
      groupId,
      rememberedFlashcards,
    );
    final int? newAchievementValue = await _fireAchievementsService
        .updateRememberedFlashcardsAmount(flashcardsIds);
    if (newAchievementValue != null) {
      await _checkRememberedFlashcardsAchievedConditionValue(
        newAchievementValue,
      );
    }
  }

  @override
  Future<void> addFinishedSession({
    required String? sessionId,
  }) async {
    final int? completedSessionsAmount =
        await _fireAchievementsService.updateFinishedSessionsAmount(sessionId);
    if (completedSessionsAmount != null) {
      await _checkFinishedSessionAchievedConditionValue(
        completedSessionsAmount,
      );
    }
  }

  @override
  void reset() {
    _allFlashcardsAmount$.add(null);
    _allFlashcardsAchievedCondition$.add(null);
    _rememberedFlashcardsAchievedCondition$.add(null);
    _finishedSessionsAchievedCondition$.add(null);
  }

  List<String> _getFlashcardsIds(
    String groupId,
    List<Flashcard> flashcards,
  ) {
    return flashcards
        .map((Flashcard flashcard) => flashcard.getId(groupId: groupId))
        .toList();
  }

  Future<void> _checkAllFlashcardsAchievedConditionValue(
    int newAchievementValue,
  ) async {
    final int? nextAchievedConditionValue =
        await _getNextAchievedConditionValue(
      achievementId: _fireAchievementsService.allFlashcardsAmountId,
      newAchievementValue: newAchievementValue,
    );
    if (nextAchievedConditionValue != null) {
      _allFlashcardsAchievedCondition$.add(nextAchievedConditionValue);
    }
  }

  Future<void> _checkRememberedFlashcardsAchievedConditionValue(
    int newAchievementValue,
  ) async {
    final int? nextAchievedConditionValue =
        await _getNextAchievedConditionValue(
      achievementId: _fireAchievementsService.rememberedFlashcardsAmountId,
      newAchievementValue: newAchievementValue,
    );
    if (nextAchievedConditionValue != null) {
      _rememberedFlashcardsAchievedCondition$.add(
        nextAchievedConditionValue,
      );
    }
  }

  Future<void> _checkFinishedSessionAchievedConditionValue(
    int newAchievementValue,
  ) async {
    final int? nextAchievedConditionValue =
        await _getNextAchievedConditionValue(
      achievementId: _fireAchievementsService.finishedSessionsAmountId,
      newAchievementValue: newAchievementValue,
    );
    if (nextAchievedConditionValue != null) {
      _finishedSessionsAchievedCondition$.add(
        nextAchievedConditionValue,
      );
    }
  }

  Future<int?> _getNextAchievedConditionValue({
    required String achievementId,
    required int newAchievementValue,
  }) async {
    return await _fireAchievementsService.getNextAchievedCondition(
      achievementType: achievementId,
      value: newAchievementValue,
    );
  }
}
