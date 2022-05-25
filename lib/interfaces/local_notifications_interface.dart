import 'package:flutter/material.dart';
import '../models/notification_model.dart';

abstract class LocalNotificationsInterface {
  Future<NotificationType?> didNotificationLaunchApp();

  Future<void> initializeSettings({
    required Function(NotificationType type) onNotificationSelected,
  });

  Future<void> setSessionNotification({
    required String sessionId,
    required String groupName,
    required TimeOfDay startTime,
    required DateTime date,
  });

  Future<void> setDayStreakLoseNotification();
}
