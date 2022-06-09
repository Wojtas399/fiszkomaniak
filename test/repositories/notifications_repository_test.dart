import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/models/notification_model.dart';
import 'package:fiszkomaniak/repositories/notifications_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalNotificationsService extends Mock
    implements LocalNotificationsService {}

void main() {
  final LocalNotificationsService localNotificationsService =
      MockLocalNotificationsService();
  late NotificationsRepository repository;

  setUp(() {
    repository = NotificationsRepository(
      localNotificationsService: localNotificationsService,
    );
  });

  tearDown(() {
    reset(localNotificationsService);
  });

  test('did notification launch app, session', () async {
    when(() => localNotificationsService.getLaunchDetails()).thenAnswer(
      (_) async => const NotificationAppLaunchDetails(true, 'session s1'),
    );

    final Notification? notification =
        await repository.didNotificationLaunchApp();

    expect(notification, SessionNotification(sessionId: 's1'));
  });

  test('did notification launch app, days streak lose', () async {
    when(() => localNotificationsService.getLaunchDetails()).thenAnswer(
      (_) async => const NotificationAppLaunchDetails(true, 'daysStreakLose'),
    );

    final Notification? notification =
        await repository.didNotificationLaunchApp();

    expect(notification, DaysStreakLoseNotification());
  });

  test('did notification launch app, null', () async {
    when(() => localNotificationsService.getLaunchDetails()).thenAnswer(
      (_) async => const NotificationAppLaunchDetails(true, null),
    );

    final Notification? notification =
        await repository.didNotificationLaunchApp();

    expect(notification, null);
  });
}
