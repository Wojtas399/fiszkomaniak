import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/remove_session_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final notificationsInterface = MockNotificationsInterface();
  final useCase = RemoveSessionUseCase(
    sessionsInterface: sessionsInterface,
    notificationsInterface: notificationsInterface,
  );

  test(
    'should call method responsible for deleting session, deleting session default notification and for deleting session scheduled notification',
    () async {
      when(
        () => sessionsInterface.removeSession('s1'),
      ).thenAnswer((_) async => '');
      when(
        () => notificationsInterface.deleteDefaultNotificationForSession(
          sessionId: 's1',
        ),
      ).thenAnswer((_) async => '');
      when(
        () => notificationsInterface.deleteScheduledNotificationForSession(
          sessionId: 's1',
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(sessionId: 's1');

      verify(
        () => sessionsInterface.removeSession('s1'),
      ).called(1);
      verify(
        () => notificationsInterface.deleteDefaultNotificationForSession(
          sessionId: 's1',
        ),
      ).called(1);
      verify(
        () => notificationsInterface.deleteScheduledNotificationForSession(
          sessionId: 's1',
        ),
      ).called(1);
    },
  );
}
