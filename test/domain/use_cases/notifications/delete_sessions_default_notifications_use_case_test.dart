import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/delete_sessions_default_notifications_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final notificationsInterface = MockNotificationsInterface();
  final useCase = DeleteSessionsDefaultNotificationsUseCase(
    sessionsInterface: sessionsInterface,
    notificationsInterface: notificationsInterface,
  );

  test(
    'for all sessions should call method responsible for deleting default notification',
    () async {
      final List<Session> sessions = [
        createSession(id: 's1'),
        createSession(id: 's2'),
      ];
      when(
        () => sessionsInterface.allSessions$,
      ).thenAnswer((_) => Stream.value(sessions));
      when(
        () => notificationsInterface.deleteDefaultNotificationForSession(
          sessionId: any(named: 'sessionId'),
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => sessionsInterface.allSessions$,
      ).called(1);
      verify(
        () => notificationsInterface.deleteDefaultNotificationForSession(
          sessionId: sessions[0].id,
        ),
      ).called(1);
      verify(
        () => notificationsInterface.deleteDefaultNotificationForSession(
          sessionId: sessions[1].id,
        ),
      ).called(1);
    },
  );
}
