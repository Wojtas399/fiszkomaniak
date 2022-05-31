import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/repositories/sessions_notifications_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalNotificationsService extends Mock
    implements LocalNotificationsService {}

void main() {
  final LocalNotificationsService localNotificationsService =
      MockLocalNotificationsService();
  late SessionsNotificationsRepository repository;

  setUp(() {
    repository = SessionsNotificationsRepository(
      localNotificationsService: localNotificationsService,
    );
  });

  tearDown(() {
    reset(localNotificationsService);
  });

  test('set scheduled notification, future time', () async {
    const String expectedId = 's1';
    const String expectedMessage =
        'Masz zaplanowaną na dzisiaj sesję z grupy group1 na godzinę 12:05';
    const String expectedPayload = 'session s1';
    final Date expectedDate = Date.now().addDays(2);
    final Time expectedTime = Time.now().addMinutes(30);
    when(
      () => localNotificationsService.addNotification(
        id: expectedId.hashCode,
        body: expectedMessage,
        dateTime: DateTime(
          expectedDate.year,
          expectedDate.month,
          expectedDate.day,
          expectedTime.hour,
          expectedTime.minute,
        ),
        payload: expectedPayload,
      ),
    ).thenAnswer((_) async => '');

    await repository.setScheduledNotification(
      sessionId: expectedId,
      groupName: 'group1',
      date: expectedDate,
      time: expectedTime,
      sessionStartTime: const Time(hour: 12, minute: 5),
    );

    verify(
      () => localNotificationsService.addNotification(
        id: expectedId.hashCode,
        body: expectedMessage,
        dateTime: DateTime(
          expectedDate.year,
          expectedDate.month,
          expectedDate.day,
          expectedTime.hour,
          expectedTime.minute,
        ),
        payload: expectedPayload,
      ),
    ).called(1);
  });

  test('set scheduled notification, past time', () async {
    when(
      () => localNotificationsService.addNotification(
        id: any(named: 'id'),
        body: any(named: 'body'),
        dateTime: any(named: 'dateTime'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => '');

    await repository.setScheduledNotification(
      sessionId: 's1',
      groupName: 'group1',
      date: const Date(year: 2022, month: 1, day: 1),
      time: const Time(hour: 10, minute: 0),
      sessionStartTime: const Time(hour: 12, minute: 30),
    );

    verifyNever(
      () => localNotificationsService.addNotification(
        id: any(named: 'id'),
        body: any(named: 'body'),
        dateTime: any(named: 'dateTime'),
        payload: any(named: 'payload'),
      ),
    );
  });

  test('set default notification, future time', () async {
    const String expectedId = 's115MIN';
    const String expectedMessage =
        'Za 15 min wybije godzina rozpoczęcia sesji z grupy group1!';
    const String expectedPayload = 'session s1';
    final Date expectedDate = Date.now().addDays(2);
    final Time time = Time.now().addMinutes(30);
    final Time time15minBefore = time.subtractMinutes(15);
    when(
      () => localNotificationsService.addNotification(
        id: expectedId.hashCode,
        body: expectedMessage,
        dateTime: DateTime(
          expectedDate.year,
          expectedDate.month,
          expectedDate.day,
          time15minBefore.hour,
          time15minBefore.minute,
        ),
        payload: expectedPayload,
      ),
    ).thenAnswer((_) async => '');

    await repository.setDefaultNotification(
      sessionId: 's1',
      groupName: 'group1',
      date: expectedDate,
      sessionStartTime: time,
    );

    verify(
      () => localNotificationsService.addNotification(
        id: expectedId.hashCode,
        body: expectedMessage,
        dateTime: DateTime(
          expectedDate.year,
          expectedDate.month,
          expectedDate.day,
          time15minBefore.hour,
          time15minBefore.minute,
        ),
        payload: expectedPayload,
      ),
    ).called(1);
  });

  test('set default notification, past time', () async {
    when(
      () => localNotificationsService.addNotification(
        id: any(named: 'id'),
        body: any(named: 'body'),
        dateTime: any(named: 'dateTime'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => '');

    await repository.setDefaultNotification(
      sessionId: 's1',
      groupName: 'group1',
      date: const Date(year: 2022, month: 1, day: 1),
      sessionStartTime: const Time(hour: 12, minute: 30),
    );

    verifyNever(
      () => localNotificationsService.addNotification(
        id: any(named: 'id'),
        body: any(named: 'body'),
        dateTime: any(named: 'dateTime'),
        payload: any(named: 'payload'),
      ),
    );
  });

  test('remove scheduled notification', () async {
    const String expectedId = 's1';
    when(
      () => localNotificationsService.cancelNotification(
        id: expectedId.hashCode,
      ),
    ).thenAnswer((_) async => '');

    await repository.removeScheduledNotification(sessionId: expectedId);

    verify(
      () => localNotificationsService.cancelNotification(
        id: expectedId.hashCode,
      ),
    ).called(1);
  });

  test('remove default notification', () async {
    const String expectedId = 's1';
    when(
      () => localNotificationsService.cancelNotification(
        id: '${expectedId}15MIN'.hashCode,
      ),
    ).thenAnswer((_) async => '');

    await repository.removeDefaultNotification(sessionId: expectedId);

    verify(
      () => localNotificationsService.cancelNotification(
        id: '${expectedId}15MIN'.hashCode,
      ),
    ).called(1);
  });
}
