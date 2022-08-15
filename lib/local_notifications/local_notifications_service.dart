import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'local_notification_model.dart';

class LocalNotificationsService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _selectedNotification$ =
      BehaviorSubject<LocalNotification?>.seeded(null);

  Stream<LocalNotification?> get selectedNotification$ =>
      _selectedNotification$.stream;

  Future<LocalNotification?> getLaunchDetails() async {
    final details = await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      return _convertPayloadToLocalNotification(details.payload);
    }
    return null;
  }

  Future<void> initializeSettings() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<void> addScheduledNotificationForSession({
    required String sessionId,
    required String groupName,
    required String startHour,
    required String startMinute,
    required DateTime dateTime,
  }) async {
    await _addNotification(
      id: sessionId.hashCode,
      body:
          'Masz zaplanowaną na dzisiaj sesję z grupy $groupName na godzinę $startHour:$startMinute',
      dateTime: dateTime,
      payload: 'session $sessionId',
    );
  }

  Future<void> addDefaultNotificationForSession({
    required String sessionId,
    required String groupName,
    required DateTime dateTime,
  }) async {
    await _addNotification(
      id: '${sessionId}15MIN'.hashCode,
      body: 'Za 15 min wybije godzina rozpoczęcia sesji z grupy $groupName!',
      dateTime: dateTime,
      payload: 'session $sessionId',
    );
  }

  Future<void> addLossOfDaysStreakNotification({
    required int year,
    required int month,
    required int day,
  }) async {
    await _addNotification(
      id: 'lossOfDaysStreak'.hashCode,
      body:
          'Masz jeszcze 5h na naukę, aby nie utracić liczby dni nauki z rzędu!',
      dateTime: DateTime(year, month, day, 19, 00),
      payload: 'lossOfDaysStreak',
    );
  }

  Future<void> cancelScheduledNotificationForSession({
    required String sessionId,
  }) async {
    await _cancelNotification(id: sessionId.hashCode);
  }

  Future<void> cancelDefaultNotificationForSession({
    required String sessionId,
  }) async {
    await _cancelNotification(id: '${sessionId}15MIN'.hashCode);
  }

  Future<void> cancelLossOfDaysStreakNotification() async {
    await _cancelNotification(id: 'lossOfDaysStreak'.hashCode);
  }

  void _onSelectNotification(String? payload) {
    _selectedNotification$.add(
      _convertPayloadToLocalNotification(payload),
    );
  }

  Future<void> _addNotification({
    required int id,
    required String body,
    required DateTime dateTime,
    required String payload,
  }) async {
    tz.initializeTimeZones();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name');
    const IOSNotificationDetails iosPlatformChannelSpecifics =
        IOSNotificationDetails(presentBadge: true);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Fiszkomaniak',
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _cancelNotification({required int id}) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  LocalNotification? _convertPayloadToLocalNotification(String? payload) {
    if (payload != null) {
      if (payload.contains('session')) {
        return LocalSessionNotification(
          sessionId: payload.split(' ')[1],
        );
      } else if (payload == 'lossOfDaysStreak') {
        return LocalLossOfDaysStreakNotification();
      }
    }
    return null;
  }
}
