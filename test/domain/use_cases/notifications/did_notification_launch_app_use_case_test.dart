import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/notification.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/did_notification_launch_app_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

void main() {
  final notificationsInterface = MockNotificationsInterface();
  final useCase = DidNotificationLaunchAppUseCase(
    notificationsInterface: notificationsInterface,
  );

  test(
    'should call method responsible for checking if notification launched app',
    () async {
      when(
        () => notificationsInterface.didNotificationLaunchApp(),
      ).thenAnswer((_) async => SessionNotification(sessionId: 's1'));

      final Notification? notification = await useCase.execute();

      expect(
        notification,
        SessionNotification(sessionId: 's1'),
      );
      verify(
        () => notificationsInterface.didNotificationLaunchApp(),
      ).called(1);
    },
  );
}
