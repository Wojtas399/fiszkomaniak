import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/set_sessions_scheduled_notifications_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

class MockGroupsInterface extends Mock implements GroupsInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

class FakeDate extends Fake implements Date {}

class FakeTime extends Fake implements Time {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final groupsInterface = MockGroupsInterface();
  final notificationsInterface = MockNotificationsInterface();
  final useCase = SetSessionsScheduledNotificationsUseCase(
    sessionsInterface: sessionsInterface,
    groupsInterface: groupsInterface,
    notificationsInterface: notificationsInterface,
  );

  setUpAll(() {
    registerFallbackValue(FakeDate());
    registerFallbackValue(FakeTime());
  });

  test(
    'for sessions, which have notification time, should call method responsible for setting scheduled notification',
    () async {
      final List<Session> sessions = [
        createSession(
          id: 's1',
          groupId: 'g1',
          date: const Date(year: 2022, month: 2, day: 2),
          startTime: const Time(hour: 11, minute: 11),
          notificationTime: null,
        ),
        createSession(
          id: 's2',
          groupId: 'g2',
          date: const Date(year: 2022, month: 1, day: 1),
          startTime: const Time(hour: 14, minute: 14),
          notificationTime: const Time(hour: 10, minute: 0),
        ),
      ];
      when(
        () => sessionsInterface.allSessions$,
      ).thenAnswer((_) => Stream.value(sessions));
      when(
        () => groupsInterface.getGroupName(groupId: 'g2'),
      ).thenAnswer((_) => Stream.value('group2'));
      when(
        () => notificationsInterface.setScheduledNotificationForSession(
          sessionId: any(named: 'sessionId'),
          groupName: any(named: 'groupName'),
          date: any(named: 'date'),
          time: any(named: 'time'),
          sessionStartTime: any(named: 'sessionStartTime'),
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => notificationsInterface.setScheduledNotificationForSession(
          sessionId: sessions[1].id,
          groupName: 'group2',
          date: sessions[1].date,
          time: const Time(hour: 10, minute: 0),
          sessionStartTime: sessions[1].startTime,
        ),
      ).called(1);
      verifyNever(
        () => notificationsInterface.setScheduledNotificationForSession(
          sessionId: sessions[0].id,
          groupName: any(named: 'groupName'),
          date: sessions[0].date,
          time: any(named: 'time'),
          sessionStartTime: sessions[0].startTime,
        ),
      );
    },
  );
}
