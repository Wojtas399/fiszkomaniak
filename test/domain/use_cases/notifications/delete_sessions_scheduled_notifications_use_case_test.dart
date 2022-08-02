import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/delete_sessions_scheduled_notifications_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final notificationsInterface = MockNotificationsInterface();
  final useCase = DeleteSessionsScheduledNotificationsUseCase(
    sessionsInterface: sessionsInterface,
    notificationsInterface: notificationsInterface,
  );

  test(
    'for sessions, which have set notification time, should call method responsible for deleting scheduled notification',
    () async {
      final List<Session> sessions = [
        createSession(
          id: 's1',
          notificationTime: const Time(hour: 12, minute: 30),
        ),
        createSession(id: 's2'),
      ];
      when(
        () => sessionsInterface.allSessions$,
      ).thenAnswer((_) => Stream.value(sessions));
      when(
        () => notificationsInterface.deleteScheduledNotificationForSession(
          sessionId: any(named: 'sessionId'),
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => sessionsInterface.allSessions$,
      ).called(1);
      verify(
        () => notificationsInterface.deleteScheduledNotificationForSession(
          sessionId: sessions[0].id,
        ),
      ).called(1);
      verifyNever(
        () => notificationsInterface.deleteScheduledNotificationForSession(
          sessionId: sessions[1].id,
        ),
      );
    },
  );
}
