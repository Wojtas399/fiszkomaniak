import 'dart:async';
import '../../../providers/dialogs_provider.dart';
import '../../../domain/entities/settings.dart';
import '../../../domain/use_cases/achievements/get_all_flashcards_achieved_condition_use_case.dart';
import '../../../domain/use_cases/achievements/get_finished_sessions_achieved_condition_use_case.dart';
import '../../../domain/use_cases/achievements/get_remembered_flashcards_achieved_condition_use_case.dart';
import '../../../domain/use_cases/settings/get_notifications_settings_use_case.dart';

class AchievementsListener {
  late final GetAllFlashcardsAchievedConditionUseCase
      _getAllFlashcardsAchievedConditionUseCase;
  late final GetRememberedFlashcardsAchievedConditionUseCase
      _getRememberedFlashcardsAchievedConditionUseCase;
  late final GetFinishedSessionsAchievedConditionUseCase
      _getFinishedSessionsAchievedConditionUseCase;
  late final GetNotificationsSettingsUseCase _getNotificationsSettingsUseCase;
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
    required GetNotificationsSettingsUseCase getNotificationsSettingsUseCase,
  }) {
    _getAllFlashcardsAchievedConditionUseCase =
        getAllFlashcardsAchievedConditionUseCase;
    _getRememberedFlashcardsAchievedConditionUseCase =
        getRememberedFlashcardsAchievedConditionUseCase;
    _getFinishedSessionsAchievedConditionUseCase =
        getFinishedSessionsAchievedConditionUseCase;
    _getNotificationsSettingsUseCase = getNotificationsSettingsUseCase;
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
              _manageAllFlashcardsAchievedCondition,
            );
  }

  void _setRememberedFlashcardsAchievedConditionListener() {
    _rememberedFlashcardsAchievedConditionListener ??=
        _getRememberedFlashcardsAchievedConditionUseCase.execute().listen(
              _manageRememberedFlashcardsAchievedCondition,
            );
  }

  void _setFinishedSessionsAchievedConditionListener() {
    _finishedSessionsAchievedConditionListener =
        _getFinishedSessionsAchievedConditionUseCase.execute().listen(
              _manageFinishedSessionsAchievedCondition,
            );
  }

  Future<void> _manageAllFlashcardsAchievedCondition(
    int? achievedConditionValue,
  ) async {
    if (achievedConditionValue != null &&
        await _areAchievementsNotificationsOn()) {
      await _showInfoAboutNewAchievedConditionOfAllFlashcards(
        achievedConditionValue,
      );
    }
  }

  Future<void> _manageRememberedFlashcardsAchievedCondition(
    int? achievedConditionValue,
  ) async {
    if (achievedConditionValue != null &&
        await _areAchievementsNotificationsOn()) {
      await _showInfoAboutNewAchievedConditionOfRememberedFlashcards(
        achievedConditionValue,
      );
    }
  }

  Future<void> _manageFinishedSessionsAchievedCondition(
    int? achievedConditionValue,
  ) async {
    if (achievedConditionValue != null &&
        await _areAchievementsNotificationsOn()) {
      await _showInfoAboutNewAchievedConditionOfFinishedSessions(
        achievedConditionValue,
      );
    }
  }

  Future<void> _showInfoAboutNewAchievedConditionOfAllFlashcards(
    int newAchievedConditionValue,
  ) async {
    await DialogsProvider.showAchievementDialog(
      achievementValue: newAchievedConditionValue,
      title: 'Utworzone fiszki',
      textBeforeAchievementValue: 'Dotychczas utworzyłeś ponad',
      textAfterAchievementValue: 'fiszek. Gratulacje!',
    );
  }

  Future<void> _showInfoAboutNewAchievedConditionOfRememberedFlashcards(
    int newAchievedConditionValue,
  ) async {
    DialogsProvider.showAchievementDialog(
      achievementValue: newAchievedConditionValue,
      title: 'Zapamiętane fiszki',
      textBeforeAchievementValue: 'Dotychczas zapamiętałeś ponad',
      textAfterAchievementValue: 'fiszek. Gratulacje!',
    );
  }

  Future<void> _showInfoAboutNewAchievedConditionOfFinishedSessions(
    int newAchievedConditionValue,
  ) async {
    await DialogsProvider.showAchievementDialog(
      achievementValue: newAchievedConditionValue,
      title: 'Ukończone sesje',
      textBeforeAchievementValue: 'Dotychczas ukończyłeś ponad',
      textAfterAchievementValue: 'sesji. Gratulacje!',
    );
  }

  Future<bool> _areAchievementsNotificationsOn() async {
    final NotificationsSettings notificationsSettings =
        await _getNotificationsSettingsUseCase.execute().first;
    return notificationsSettings.areAchievementsNotificationsOn;
  }
}
