import 'package:fiszkomaniak/interfaces/local_notifications_interface.dart';
import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/models/notification_model.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';

class LocalNotificationsRepository implements LocalNotificationsInterface {
  late final LocalNotificationsService _localNotificationsService;

  LocalNotificationsRepository({
    required LocalNotificationsService localNotificationsService,
  }) {
    _localNotificationsService = localNotificationsService;
  }

  @override
  Future<NotificationType?> didNotificationLaunchApp() async {
    try {
      final details = await _localNotificationsService.getLaunchDetails();
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
      await _localNotificationsService.initializeSettings(
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
      await _localNotificationsService.addNotification(
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
