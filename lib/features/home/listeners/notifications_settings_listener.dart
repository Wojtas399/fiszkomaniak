import 'dart:async';
import '../../../domain/entities/settings.dart';
import '../../../domain/use_cases/notifications/delete_loss_of_days_streak_notification_use_case.dart';
import '../../../domain/use_cases/notifications/delete_sessions_default_notifications_use_case.dart';
import '../../../domain/use_cases/notifications/delete_sessions_scheduled_notifications_use_case.dart';
import '../../../domain/use_cases/notifications/set_loss_of_days_streak_notification_use_case.dart';
import '../../../domain/use_cases/notifications/set_sessions_default_notifications_use_case.dart';
import '../../../domain/use_cases/notifications/set_sessions_scheduled_notifications_use_case.dart';
import '../../../domain/use_cases/settings/get_notifications_settings_use_case.dart';

class NotificationsSettingsListener {
  late final GetNotificationsSettingsUseCase _getNotificationsSettingsUseCase;
  late final SetSessionsDefaultNotificationsUseCase
      _setSessionsDefaultNotificationsUseCase;
  late final SetSessionsScheduledNotificationsUseCase
      _setSessionsScheduledNotificationsUseCase;
  late final SetLossOfDaysStreakNotificationUseCase
      _setLossOfDaysStreakNotificationUseCase;
  late final DeleteSessionsDefaultNotificationsUseCase
      _deleteSessionsDefaultNotificationsUseCase;
  late final DeleteSessionsScheduledNotificationsUseCase
      _deleteSessionsScheduledNotificationsUseCase;
  late final DeleteLossOfDaysStreakNotificationUseCase
      _deleteLossOfDaysStreakNotificationUseCase;
  NotificationsSettings? _currentSettings;
  StreamSubscription<NotificationsSettings>? _notificationsSettingsListener;

  NotificationsSettingsListener({
    required GetNotificationsSettingsUseCase getNotificationsSettingsUseCase,
    required SetSessionsDefaultNotificationsUseCase
        setSessionsDefaultNotificationsUseCase,
    required SetSessionsScheduledNotificationsUseCase
        setSessionsScheduledNotificationsUseCase,
    required SetLossOfDaysStreakNotificationUseCase
        setLossOfDaysStreakNotificationUseCase,
    required DeleteSessionsDefaultNotificationsUseCase
        deleteSessionsDefaultNotificationsUseCase,
    required DeleteSessionsScheduledNotificationsUseCase
        deleteSessionsScheduledNotificationsUseCase,
    required DeleteLossOfDaysStreakNotificationUseCase
        deleteLossOfDaysStreakNotificationUseCase,
  }) {
    _getNotificationsSettingsUseCase = getNotificationsSettingsUseCase;
    _setSessionsDefaultNotificationsUseCase =
        setSessionsDefaultNotificationsUseCase;
    _setSessionsScheduledNotificationsUseCase =
        setSessionsScheduledNotificationsUseCase;
    _setLossOfDaysStreakNotificationUseCase =
        setLossOfDaysStreakNotificationUseCase;
    _deleteSessionsDefaultNotificationsUseCase =
        deleteSessionsDefaultNotificationsUseCase;
    _deleteSessionsScheduledNotificationsUseCase =
        deleteSessionsScheduledNotificationsUseCase;
    _deleteLossOfDaysStreakNotificationUseCase =
        deleteLossOfDaysStreakNotificationUseCase;
  }

  Future<void> initialize() async {
    _setNotificationsSettingsListener();
  }

  void dispose() {
    _currentSettings = null;
    _notificationsSettingsListener?.cancel();
  }

  void _setNotificationsSettingsListener() {
    _notificationsSettingsListener ??= _getNotificationsSettingsUseCase
        .execute()
        .listen(_manageNotificationsSettings);
  }

  Future<void> _manageNotificationsSettings(
    NotificationsSettings newSettings,
  ) async {
    _manageSessionsScheduledNotificationsStatus(
      newSettings.areSessionsScheduledNotificationsOn,
    );
    _manageSessionsDefaultNotificationsStatus(
      newSettings.areSessionsDefaultNotificationsOn,
    );
    _manageLossOfDaysStreakNotificationsStatus(
      newSettings.areLossOfDaysStreakNotificationsOn,
    );
  }

  Future<void> _manageSessionsScheduledNotificationsStatus(
    bool newValue,
  ) async {
    bool? currentValue = _currentSettings?.areSessionsScheduledNotificationsOn;
    if (newValue != currentValue) {
      if (newValue) {
        await _setSessionsScheduledNotificationsUseCase.execute();
      } else {
        await _deleteSessionsScheduledNotificationsUseCase.execute();
      }
      _currentSettings = _currentSettings?.copyWith(
        areSessionsScheduledNotificationsOn: newValue,
      );
    }
  }

  Future<void> _manageSessionsDefaultNotificationsStatus(
    bool newValue,
  ) async {
    bool? currentValue = _currentSettings?.areSessionsDefaultNotificationsOn;
    if (newValue != currentValue) {
      if (newValue) {
        await _setSessionsDefaultNotificationsUseCase.execute();
      } else {
        await _deleteSessionsDefaultNotificationsUseCase.execute();
      }
      _currentSettings = _currentSettings?.copyWith(
        areSessionsDefaultNotificationsOn: newValue,
      );
    }
  }

  Future<void> _manageLossOfDaysStreakNotificationsStatus(
    bool newValue,
  ) async {
    bool? currentValue = _currentSettings?.areLossOfDaysStreakNotificationsOn;
    if (newValue != currentValue) {
      if (newValue) {
        await _setLossOfDaysStreakNotificationUseCase.execute();
      } else {
        await _deleteLossOfDaysStreakNotificationUseCase.execute();
      }
      _currentSettings = _currentSettings?.copyWith(
        areLossOfDaysStreakNotificationsOn: newValue,
      );
    }
  }
}
