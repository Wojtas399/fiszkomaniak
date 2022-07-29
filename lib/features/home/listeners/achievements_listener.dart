import 'dart:async';
import '../../../components/dialogs/dialogs.dart';
import '../../../domain/use_cases/achievements/get_all_flashcards_achieved_condition_use_case.dart';
import '../../../domain/use_cases/achievements/get_finished_sessions_achieved_condition_use_case.dart';
import '../../../domain/use_cases/achievements/get_remembered_flashcards_achieved_condition_use_case.dart';

class AchievementsListener {
  late final GetAllFlashcardsAchievedConditionUseCase
      _getAllFlashcardsAchievedConditionUseCase;
  late final GetRememberedFlashcardsAchievedConditionUseCase
      _getRememberedFlashcardsAchievedConditionUseCase;
  late final GetFinishedSessionsAchievedConditionUseCase
      _getFinishedSessionsAchievedConditionUseCase;
  StreamSubscription<int?>? _allFlashcardsAchievedConditionListener;
  StreamSubscription<int?>? _rememberedFlashcardsAchievedConditionListener;
  StreamSubscription<int?>? _finishedSessionsAchievedConditionListener;

  AchievementsListener({
    required GetAllFlashcardsAchievedConditionUseCase
        getAllFlashcardsAchievedConditionUseCase,
    required GetRememberedFlashcardsAchievedConditionUseCase
        getRememberedFlashcardsAchievedConditionUseCase,
    required GetFinishedSessionsAchievedConditionUseCase
        getFinishedSessionsAchievedConditionUseCase,
  }) {
    _getAllFlashcardsAchievedConditionUseCase =
        getAllFlashcardsAchievedConditionUseCase;
    _getRememberedFlashcardsAchievedConditionUseCase =
        getRememberedFlashcardsAchievedConditionUseCase;
    _getFinishedSessionsAchievedConditionUseCase =
        getFinishedSessionsAchievedConditionUseCase;
  }

  void initialize() {
    _setAllFlashcardsAchievedConditionListener();
    _setRememberedFlashcardsAchievedConditionListener();
    _setFinishedSessionsAchievedConditionListener();
  }

  void dispose() {
    _allFlashcardsAchievedConditionListener?.cancel();
    _rememberedFlashcardsAchievedConditionListener?.cancel();
    _finishedSessionsAchievedConditionListener?.cancel();
    _allFlashcardsAchievedConditionListener = null;
    _rememberedFlashcardsAchievedConditionListener = null;
    _finishedSessionsAchievedConditionListener = null;
  }

  void _setAllFlashcardsAchievedConditionListener() {
    _allFlashcardsAchievedConditionListener ??=
        _getAllFlashcardsAchievedConditionUseCase.execute().listen(
      (int? achievedConditionValue) async {
        if (achievedConditionValue != null) {
          await _showInfoAboutNewAchievedConditionOfAllFlashcards(
            achievedConditionValue,
          );
        }
      },
    );
  }

  void _setRememberedFlashcardsAchievedConditionListener() {
    _rememberedFlashcardsAchievedConditionListener ??=
        _getRememberedFlashcardsAchievedConditionUseCase.execute().listen(
      (int? achievedConditionValue) async {
        if (achievedConditionValue != null) {
          await _showInfoAboutNewAchievedConditionOfRememberedFlashcards(
            achievedConditionValue,
          );
        }
      },
    );
  }

  void _setFinishedSessionsAchievedConditionListener() {
    _finishedSessionsAchievedConditionListener =
        _getFinishedSessionsAchievedConditionUseCase.execute().listen(
      (int? achievedConditionValue) async {
        if (achievedConditionValue != null) {
          await _showInfoAboutNewAchievedConditionOfFinishedSessions(
            achievedConditionValue,
          );
        }
      },
    );
  }

  Future<void> _showInfoAboutNewAchievedConditionOfAllFlashcards(
    int newAchievedConditionValue,
  ) async {
    await Dialogs.showAchievementDialog(
      achievementValue: newAchievedConditionValue,
      title: 'Utworzone fiszki',
      textBeforeAchievementValue: 'Dotychczas utworzyłeś ponad',
      textAfterAchievementValue: 'fiszek. Gratulacje!',
    );
  }

  Future<void> _showInfoAboutNewAchievedConditionOfRememberedFlashcards(
    int newAchievedConditionValue,
  ) async {
    Dialogs.showAchievementDialog(
      achievementValue: newAchievedConditionValue,
      title: 'Zapamiętane fiszki',
      textBeforeAchievementValue: 'Dotychczas zapamiętałeś ponad',
      textAfterAchievementValue: 'fiszek. Gratulacje!',
    );
  }

  Future<void> _showInfoAboutNewAchievedConditionOfFinishedSessions(
    int newAchievedConditionValue,
  ) async {
    await Dialogs.showAchievementDialog(
      achievementValue: newAchievedConditionValue,
      title: 'Ukończone sesje',
      textBeforeAchievementValue: 'Dotychczas ukończyłeś ponad',
      textAfterAchievementValue: 'sesji. Gratulacje!',
    );
  }
}
