import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/set_sessions_default_notifications_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

class MockGroupsInterface extends Mock implements GroupsInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final groupsInterface = MockGroupsInterface();
  final notificationsInterface = MockNotificationsInterface();
  final useCase = SetSessionsDefaultNotificationsUseCase(
    sessionsInterface: sessionsInterface,
    groupsInterface: groupsInterface,
    notificationsInterface: notificationsInterface,
  );

  test(
    'for all sessions should call method responsible for setting notification 15 min before start time',
    () async {
      final List<Session> sessions = [
        createSession(
          id: 's1',
          groupId: 'g1',
          date: const Date(year: 2022, month: 5, day: 2),
          startTime: const Time(hour: 12, minute: 30),
        ),
        createSession(
          id: 's2',
          groupId: 'g2',
          date: const Date(year: 2022, month: 4, day: 4),
          startTime: const Time(hour: 9, minute: 0),
        ),
      ];
      when(
        () => sessionsInterface.allSessions$,
      ).thenAnswer((_) => Stream.value(sessions));
      when(
        () => groupsInterface.getGroupName(
          groupId: sessions[0].groupId,
        ),
      ).thenAnswer((_) => Stream.value('group1'));
      when(
        () => groupsInterface.getGroupName(
          groupId: sessions[1].groupId,
        ),
      ).thenAnswer((_) => Stream.value('group2'));
      when(
        () => notificationsInterface.setNotificationForSession15minBeforeStartTime(
          sessionId: sessions[0].id,
          groupName: 'group1',
          date: sessions[0].date,
          sessionStartTime: sessions[0].startTime,
        ),
      ).thenAnswer((_) async => '');
      when(
        () => notificationsInterface.setNotificationForSession15minBeforeStartTime(
          sessionId: sessions[1].id,
          groupName: 'group2',
          date: sessions[1].date,
          sessionStartTime: sessions[1].startTime,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => notificationsInterface.setNotificationForSession15minBeforeStartTime(
          sessionId: sessions[0].id,
          groupName: 'group1',
          date: sessions[0].date,
          sessionStartTime: sessions[0].startTime,
        ),
      ).called(1);
      verify(
        () => notificationsInterface.setNotificationForSession15minBeforeStartTime(
          sessionId: sessions[1].id,
          groupName: 'group2',
          date: sessions[1].date,
          sessionStartTime: sessions[1].startTime,
        ),
      ).called(1);
    },
  );
}
