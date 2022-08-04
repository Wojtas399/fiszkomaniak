import '../../../domain/entities/settings.dart';
import '../../../interfaces/settings_interface.dart';

class GetNotificationsSettingsUseCase {
  late final SettingsInterface _settingsInterface;

  GetNotificationsSettingsUseCase({
    required SettingsInterface settingsInterface,
  }) {
    _settingsInterface = settingsInterface;
  }

  Stream<NotificationsSettings> execute() {
    return _settingsInterface.notificationsSettings$;
  }
}
