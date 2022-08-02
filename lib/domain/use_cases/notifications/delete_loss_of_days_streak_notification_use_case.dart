import '../../../interfaces/notifications_interface.dart';

class DeleteLossOfDaysStreakNotificationUseCase {
  late final NotificationsInterface _notificationsInterface;

  DeleteLossOfDaysStreakNotificationUseCase({
    required NotificationsInterface notificationsInterface,
  }) {
    _notificationsInterface = notificationsInterface;
  }

  Future<void> execute() async {
    await _notificationsInterface.deleteLossOfDaysStreakNotification();
  }
}
