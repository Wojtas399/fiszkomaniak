import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';

class LoadNotificationsSettingsUseCase {
  late final NotificationsSettingsInterface _notificationsSettingsInterface;

  LoadNotificationsSettingsUseCase({
    required NotificationsSettingsInterface notificationsSettingsInterface,
  }) {
    _notificationsSettingsInterface = notificationsSettingsInterface;
  }

  Future<void> execute() async {
    await _notificationsSettingsInterface.loadSettings();
  }
}
