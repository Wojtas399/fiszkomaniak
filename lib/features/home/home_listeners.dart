import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/use_cases/achievements/get_all_flashcards_achieved_condition_use_case.dart';
import '../../domain/use_cases/achievements/get_finished_sessions_achieved_condition_use_case.dart';
import '../../domain/use_cases/achievements/get_remembered_flashcards_achieved_condition_use_case.dart';
import '../../domain/use_cases/notifications/delete_loss_of_days_streak_notification_use_case.dart';
import '../../domain/use_cases/notifications/delete_sessions_default_notifications_use_case.dart';
import '../../domain/use_cases/notifications/delete_sessions_scheduled_notifications_use_case.dart';
import '../../domain/use_cases/notifications/did_notification_launch_app_use_case.dart';
import '../../domain/use_cases/notifications/get_selected_notification_use_case.dart';
import '../../domain/use_cases/notifications/set_loss_of_days_streak_notification_use_case.dart';
import '../../domain/use_cases/notifications/set_sessions_default_notifications_use_case.dart';
import '../../domain/use_cases/notifications/set_sessions_scheduled_notifications_use_case.dart';
import '../../domain/use_cases/notifications_settings/get_notifications_settings_use_case.dart';
import '../../interfaces/achievements_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../interfaces/notifications_interface.dart';
import '../../interfaces/notifications_settings_interface.dart';
import '../../interfaces/sessions_interface.dart';
import '../../interfaces/user_interface.dart';
import '../../providers/date_provider.dart';
import 'listeners/achievements_listener.dart';
import 'listeners/notifications_listener.dart';
import 'listeners/notifications_settings_listener.dart';

class HomeListeners extends StatelessWidget {
  final Widget child;

  const HomeListeners({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final AchievementsListener achievementsListener = AchievementsListener(
      getAllFlashcardsAchievedConditionUseCase:
          GetAllFlashcardsAchievedConditionUseCase(
        achievementsInterface: context.read<AchievementsInterface>(),
      ),
      getRememberedFlashcardsAchievedConditionUseCase:
          GetRememberedFlashcardsAchievedConditionUseCase(
        achievementsInterface: context.read<AchievementsInterface>(),
      ),
      getFinishedSessionsAchievedConditionUseCase:
          GetFinishedSessionsAchievedConditionUseCase(
        achievementsInterface: context.read<AchievementsInterface>(),
      ),
    );
    final NotificationsListener notificationsListener = NotificationsListener(
      getSelectedNotificationUseCase: GetSelectedNotificationUseCase(
        notificationsInterface: context.read<NotificationsInterface>(),
      ),
      didNotificationLaunchAppUseCase: DidNotificationLaunchAppUseCase(
        notificationsInterface: context.read<NotificationsInterface>(),
      ),
    );
    final NotificationsSettingsListener notificationsSettingsListener =
        NotificationsSettingsListener(
      getNotificationsSettingsUseCase: GetNotificationsSettingsUseCase(
        notificationsSettingsInterface:
            context.read<NotificationsSettingsInterface>(),
      ),
      setSessionsDefaultNotificationsUseCase:
          SetSessionsDefaultNotificationsUseCase(
        sessionsInterface: context.read<SessionsInterface>(),
        groupsInterface: context.read<GroupsInterface>(),
        notificationsInterface: context.read<NotificationsInterface>(),
      ),
      setSessionsScheduledNotificationsUseCase:
          SetSessionsScheduledNotificationsUseCase(
        sessionsInterface: context.read<SessionsInterface>(),
        groupsInterface: context.read<GroupsInterface>(),
        notificationsInterface: context.read<NotificationsInterface>(),
      ),
      setLossOfDaysStreakNotificationUseCase:
          SetLossOfDaysStreakNotificationUseCase(
        userInterface: context.read<UserInterface>(),
        notificationsInterface: context.read<NotificationsInterface>(),
        dateProvider: DateProvider(),
      ),
      deleteSessionsDefaultNotificationsUseCase:
          DeleteSessionsDefaultNotificationsUseCase(
        sessionsInterface: context.read<SessionsInterface>(),
        notificationsInterface: context.read<NotificationsInterface>(),
      ),
      deleteSessionsScheduledNotificationsUseCase:
          DeleteSessionsScheduledNotificationsUseCase(
        sessionsInterface: context.read<SessionsInterface>(),
        notificationsInterface: context.read<NotificationsInterface>(),
      ),
      deleteLossOfDaysStreakNotificationUseCase:
          DeleteLossOfDaysStreakNotificationUseCase(
        notificationsInterface: context.read<NotificationsInterface>(),
      ),
    );
    achievementsListener.initialize();
    notificationsListener.initialize();
    notificationsSettingsListener.initialize();
    return Provider(
      create: (_) => achievementsListener,
      dispose: (_, AchievementsListener listener) => listener.dispose(),
      child: Provider(
        create: (_) => notificationsListener,
        dispose: (_, NotificationsListener listener) => listener.dispose(),
        child: Provider(
          create: (_) => notificationsSettingsListener,
          dispose: (_, NotificationsSettingsListener listener) =>
              listener.dispose(),
          child: child,
        ),
      ),
    );
  }
}
