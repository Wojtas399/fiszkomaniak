import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/notification.dart';
import 'package:fiszkomaniak/domain/repositories/notifications_repository.dart';
import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/local_notifications/local_notification_model.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/utils/time_utils.dart';
import 'package:fiszkomaniak/utils/utils.dart';

class MockLocalNotificationsService extends Mock
    implements LocalNotificationsService {}

class MockTimeUtils extends Mock implements TimeUtils {}

void main() {
  final localNotificationsService = MockLocalNotificationsService();
  final timeUtils = MockTimeUtils();
  late NotificationsRepository repository;

  setUp(
    () => repository = NotificationsRepository(
      localNotificationsService: localNotificationsService,
      timeUtils: timeUtils,
    ),
  );

  tearDown(() {
    reset(localNotificationsService);
    reset(timeUtils);
  });

  test(
    'selected notification, should return stream which contains converted local notification',
    () async {
      when(
        () => localNotificationsService.selectedNotification$,
      ).thenAnswer(
        (_) => Stream.value(LocalLossOfDaysStreakNotification()),
      );

      final Stream<Notification?> notification$ =
          repository.selectedNotification$;

      expect(
        await notification$.first,
        DaysStreakLoseNotification(),
      );
    },
  );

  test(
    'did notification launch app, should return notification which launched app',
    () async {
      when(
        () => localNotificationsService.getLaunchDetails(),
      ).thenAnswer(
        (_) async => LocalSessionNotification(sessionId: 's1'),
      );

      final Notification? notification =
          await repository.didNotificationLaunchApp();

      expect(
        notification,
        SessionNotification(sessionId: 's1'),
      );
    },
  );

  test(
    'did notification launch app, should return null as default',
    () async {
      when(
        () => localNotificationsService.getLaunchDetails(),
      ).thenAnswer((_) async => null);

      final Notification? notification =
          await repository.didNotificationLaunchApp();

      expect(notification, null);
    },
  );

  test(
    'initialize settings, should call method responsible for initializing notifications settings',
    () async {
      when(
        () => localNotificationsService.initializeSettings(),
      ).thenAnswer((_) async => '');

      await repository.initializeSettings();

      verify(
        () => localNotificationsService.initializeSettings(),
      ).called(1);
    },
  );

  group(
    'set scheduled notification for session',
    () {
      const String sessionId = 's1';
      const String groupName = 'group 1';
      const Date date = Date(year: 2022, month: 2, day: 2);
      const Time time = Time(hour: 12, minute: 30);
      const Time sessionStartTime = Time(hour: 15, minute: 30);

      setUp(() {
        when(
          () => localNotificationsService.addScheduledNotificationForSession(
            sessionId: sessionId,
            groupName: groupName,
            startHour: Utils.twoDigits(sessionStartTime.hour),
            startMinute: Utils.twoDigits(sessionStartTime.minute),
            dateTime: DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            ),
          ),
        ).thenAnswer((_) async => '');
      });

      test(
        'should call method responsible for adding scheduled notification for session',
        () async {
          when(
            () => timeUtils.isPastTime(time, date),
          ).thenReturn(false);
          when(
            () => timeUtils.isNow(time, date),
          ).thenReturn(false);

          await repository.setScheduledNotificationForSession(
            sessionId: sessionId,
            groupName: groupName,
            date: date,
            time: time,
            sessionStartTime: sessionStartTime,
          );

          verify(
            () => localNotificationsService.addScheduledNotificationForSession(
              sessionId: sessionId,
              groupName: groupName,
              startHour: Utils.twoDigits(sessionStartTime.hour),
              startMinute: Utils.twoDigits(sessionStartTime.minute),
              dateTime: DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              ),
            ),
          ).called(1);
        },
      );

      test(
        'should not call method responsible for adding scheduled notification for session if time and date are from the past',
        () async {
          when(
            () => timeUtils.isPastTime(time, date),
          ).thenReturn(true);

          await repository.setScheduledNotificationForSession(
            sessionId: sessionId,
            groupName: groupName,
            date: date,
            time: time,
            sessionStartTime: sessionStartTime,
          );

          verifyNever(
            () => localNotificationsService.addScheduledNotificationForSession(
              sessionId: sessionId,
              groupName: groupName,
              startHour: Utils.twoDigits(sessionStartTime.hour),
              startMinute: Utils.twoDigits(sessionStartTime.minute),
              dateTime: DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              ),
            ),
          );
        },
      );

      test(
        'should not call method responsible for adding scheduled notification for session if time and date are from now',
        () async {
          when(
            () => timeUtils.isPastTime(time, date),
          ).thenReturn(false);
          when(
            () => timeUtils.isNow(time, date),
          ).thenReturn(true);

          await repository.setScheduledNotificationForSession(
            sessionId: sessionId,
            groupName: groupName,
            date: date,
            time: time,
            sessionStartTime: sessionStartTime,
          );

          verifyNever(
            () => localNotificationsService.addScheduledNotificationForSession(
              sessionId: sessionId,
              groupName: groupName,
              startHour: Utils.twoDigits(sessionStartTime.hour),
              startMinute: Utils.twoDigits(sessionStartTime.minute),
              dateTime: DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'set default notification for session',
    () {
      const String sessionId = 's1';
      const String groupName = 'group 1';
      const Date date = Date(year: 2022, month: 2, day: 2);
      const Time sessionStartTime = Time(hour: 12, minute: 0);
      final Time time15minBefore = sessionStartTime.subtractMinutes(15);

      setUp(() {
        when(
          () => localNotificationsService.addDefaultNotificationForSession(
            sessionId: sessionId,
            groupName: groupName,
            dateTime: DateTime(
              date.year,
              date.month,
              date.day,
              time15minBefore.hour,
              time15minBefore.minute,
            ),
          ),
        ).thenAnswer((_) async => '');
      });

      test(
        'should call method responsible for adding default notification for session',
        () async {
          when(
            () => timeUtils.isPastTime(time15minBefore, date),
          ).thenReturn(false);
          when(
            () => timeUtils.isNow(time15minBefore, date),
          ).thenReturn(false);

          await repository.setDefaultNotificationForSession(
            sessionId: sessionId,
            groupName: groupName,
            date: date,
            sessionStartTime: sessionStartTime,
          );

          verify(
            () => localNotificationsService.addDefaultNotificationForSession(
              sessionId: sessionId,
              groupName: groupName,
              dateTime: DateTime(
                date.year,
                date.month,
                date.day,
                time15minBefore.hour,
                time15minBefore.minute,
              ),
            ),
          ).called(1);
        },
      );

      test(
        'should not call method responsible for adding default notification for session if time from 15 min earlier and date are from the past',
        () async {
          when(
            () => timeUtils.isPastTime(time15minBefore, date),
          ).thenReturn(true);

          await repository.setDefaultNotificationForSession(
            sessionId: sessionId,
            groupName: groupName,
            date: date,
            sessionStartTime: sessionStartTime,
          );

          verifyNever(
            () => localNotificationsService.addDefaultNotificationForSession(
              sessionId: sessionId,
              groupName: groupName,
              dateTime: DateTime(
                date.year,
                date.month,
                date.day,
                time15minBefore.hour,
                time15minBefore.minute,
              ),
            ),
          );
        },
      );

      test(
        'should not call method responsible for adding default notification for session if time from 15 min earlier and date are from now',
        () async {
          when(
            () => timeUtils.isPastTime(time15minBefore, date),
          ).thenReturn(false);
          when(
            () => timeUtils.isNow(time15minBefore, date),
          ).thenReturn(true);

          await repository.setDefaultNotificationForSession(
            sessionId: sessionId,
            groupName: groupName,
            date: date,
            sessionStartTime: sessionStartTime,
          );

          verifyNever(
            () => localNotificationsService.addDefaultNotificationForSession(
              sessionId: sessionId,
              groupName: groupName,
              dateTime: DateTime(
                date.year,
                date.month,
                date.day,
                time15minBefore.hour,
                time15minBefore.minute,
              ),
            ),
          );
        },
      );
    },
  );

  test(
    'set loss of days streak notification, should call method responsible for adding notification for loss of days streak',
    () async {
      const Date date = Date(year: 2022, month: 2, day: 2);
      when(
        () => localNotificationsService.addLossOfDaysStreakNotification(
          year: date.year,
          month: date.month,
          day: date.day,
        ),
      ).thenAnswer((_) async => '');

      await repository.setLossOfDaysStreakNotification(date: date);

      verify(
        () => localNotificationsService.addLossOfDaysStreakNotification(
          year: date.year,
          month: date.month,
          day: date.day,
        ),
      ).called(1);
    },
  );

  test(
    'delete scheduled notification for session, should call method responsible for cancelling scheduled notification for session',
    () async {
      const String sessionId = 's1';
      when(
        () => localNotificationsService.cancelScheduledNotificationForSession(
          sessionId: sessionId,
        ),
      ).thenAnswer((_) async => '');

      await repository.deleteScheduledNotificationForSession(
        sessionId: sessionId,
      );

      verify(
        () => localNotificationsService.cancelScheduledNotificationForSession(
          sessionId: sessionId,
        ),
      ).called(1);
    },
  );

  test(
    'delete default notification for session, should call method responsible for cancelling default notification for session',
    () async {
      const String sessionId = 's1';
      when(
        () => localNotificationsService.cancelDefaultNotificationForSession(
          sessionId: sessionId,
        ),
      ).thenAnswer((_) async => '');

      await repository.deleteDefaultNotificationForSession(
        sessionId: sessionId,
      );

      verify(
        () => localNotificationsService.cancelDefaultNotificationForSession(
          sessionId: sessionId,
        ),
      ).called(1);
    },
  );

  test(
    'delete loss of days streak notification, should call method responsible for cancelling days streak lose notification',
    () async {
      when(
        () => localNotificationsService.cancelLossOfDaysStreakNotification(),
      ).thenAnswer((_) async => '');

      await repository.deleteLossOfDaysStreakNotification();

      verify(
        () => localNotificationsService.cancelLossOfDaysStreakNotification(),
      ).called(1);
    },
  );
}
