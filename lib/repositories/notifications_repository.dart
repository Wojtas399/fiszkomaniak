import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/models/notification_model.dart';
import 'package:fiszkomaniak/notifications/notifications_service.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';

class NotificationsRepository implements NotificationsInterface {
  late final NotificationsService _notificationsService;

  NotificationsRepository({
    required NotificationsService notificationsService,
  }) {
    _notificationsService = notificationsService;
  }

  @override
  Future<NotificationType?> didNotificationLaunchApp() async {
    try {
      final details = await _notificationsService.getLaunchDetails();
      final notification = _getNotificationType(details?.payload);
      if (details != null &&
          details.didNotificationLaunchApp &&
          notification != null) {
        return notification;
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> initializeSettings({
    required Function(NotificationType type) onNotificationSelected,
  }) async {
    try {
      await _notificationsService.initializeSettings(
        onNotificationSelected: (String? payload) {
          final NotificationType? notification = _getNotificationType(payload);
          if (notification != null) {
            onNotificationSelected(notification);
          }
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> setSessionNotification({
    required String sessionId,
    required String groupName,
    required TimeOfDay startTime,
    required DateTime date,
  }) async {
    try {
      final String hour = Utils.twoDigits(startTime.hour);
      final String minute = Utils.twoDigits(startTime.minute);
      await _notificationsService.setNotification(
        id: sessionId.hashCode,
        body:
            'Masz zaplanowaną sesję z grupy $groupName na godzinę $hour:$minute',
        date: date,
        payload: 'session $sessionId',
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> setDayStreakLoseNotification() async {
    //TODO
  }

  NotificationType? _getNotificationType(String? payload) {
    if (payload == null) {
      return null;
    }
    if (payload.contains('session')) {
      return NotificationTypeSession(sessionId: payload.split(' ')[1]);
    } else if (payload == 'dayStreakLose') {
      return NotificationTypeDayStreakLose();
    }
    return null;
  }
}
