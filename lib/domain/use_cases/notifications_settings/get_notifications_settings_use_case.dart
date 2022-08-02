import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import '../../entities/notifications_settings.dart';

class GetNotificationsSettingsUseCase {
  late final NotificationsSettingsInterface _notificationsSettingsInterface;

  GetNotificationsSettingsUseCase({
    required NotificationsSettingsInterface notificationsSettingsInterface,
  }) {
    _notificationsSettingsInterface = notificationsSettingsInterface;
  }

  Stream<NotificationsSettings> execute() {
    return _notificationsSettingsInterface.notificationsSettings$;
  }
}
