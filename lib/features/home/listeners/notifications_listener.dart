import 'dart:async';
import '../../../config/navigation.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/use_cases/notifications/did_notification_launch_app_use_case.dart';
import '../../../domain/use_cases/notifications/get_selected_notification_use_case.dart';
import '../../../features/session_preview/bloc/session_preview_mode.dart';

class NotificationsListener {
  late final GetSelectedNotificationUseCase _getSelectedNotificationUseCase;
  late final DidNotificationLaunchAppUseCase _didNotificationLaunchAppUseCase;
  StreamSubscription<Notification?>? _notificationsListener;

  NotificationsListener({
    required GetSelectedNotificationUseCase getSelectedNotificationUseCase,
    required DidNotificationLaunchAppUseCase didNotificationLaunchAppUseCase,
  }) {
    _getSelectedNotificationUseCase = getSelectedNotificationUseCase;
    _didNotificationLaunchAppUseCase = didNotificationLaunchAppUseCase;
  }

  Future<void> initialize() async {
    await _checkIfNotificationLaunchedApp();
    _setNotificationsListener();
  }

  void dispose() {
    _notificationsListener?.cancel();
  }

  Future<void> _checkIfNotificationLaunchedApp() async {
    _manageNotification(
      await _didNotificationLaunchAppUseCase.execute(),
    );
  }

  void _setNotificationsListener() {
    _notificationsListener ??=
        _getSelectedNotificationUseCase.execute().listen(_manageNotification);
  }

  void _manageNotification(Notification? notification) {
    if (notification is SessionNotification) {
      _navigateToSessionPreview(notification.sessionId);
    }
  }

  void _navigateToSessionPreview(String sessionId) {
    Navigation.navigateToSessionPreview(
      SessionPreviewModeNormal(sessionId: sessionId),
    );
  }
}
