import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/repositories/achievements_notifications_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalNotificationsService extends Mock
    implements LocalNotificationsService {}

void main() {
  final LocalNotificationsService localNotificationsService =
      MockLocalNotificationsService();
  late AchievementsNotificationsRepository repository;

  setUp(() {
    repository = AchievementsNotificationsRepository(
      localNotificationsService: localNotificationsService,
    );
  });

  tearDown(() {
    reset(localNotificationsService);
  });

  test('set days streak lose notification', () async {
    when(
      () => localNotificationsService.addNotification(
        id: any(named: 'id'),
        body: any(named: 'body'),
        dateTime: any(named: 'dateTime'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => '');

    await repository.setDaysStreakLoseNotification(
      date: const Date(year: 2022, month: 1, day: 1),
    );

    verify(
      () => localNotificationsService.addNotification(
        id: 'daysStreakLose'.hashCode,
        body:
            'Masz jeszcze 5h na naukę, aby nie utracić liczby dni nauki z rzędu!',
        dateTime: DateTime(2022, 1, 1, 19, 0),
        payload: 'daysStreakLose',
      ),
    ).called(1);
  });

  test('remove days streak lose notification', () async {
    when(
      () => localNotificationsService.cancelNotification(id: any(named: 'id')),
    ).thenAnswer((_) async => '');

    await repository.removeDaysStreakLoseNotification();

    verify(
      () => localNotificationsService.cancelNotification(
        id: 'daysStreakLose'.hashCode,
      ),
    ).called(1);
  });
}
