import '../../../interfaces/notifications_interface.dart';

class InitializeNotificationsSettingsUseCase {
  late final NotificationsInterface _notificationsInterface;

  InitializeNotificationsSettingsUseCase({
    required NotificationsInterface notificationsInterface,
  }) {
    _notificationsInterface = notificationsInterface;
  }

  Future<void> execute() async {
    await _notificationsInterface.initializeSettings();
  }
}
