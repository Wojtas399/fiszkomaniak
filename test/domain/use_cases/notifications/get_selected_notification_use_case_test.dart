import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/notification.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/get_selected_notification_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

void main() {
  final notificationsInterface = MockNotificationsInterface();
  final useCase = GetSelectedNotificationUseCase(
    notificationsInterface: notificationsInterface,
  );

  test(
    'should return stream which contains selected notification',
    () async {
      final Notification expectedNotification = DaysStreakLoseNotification();
      when(
        () => notificationsInterface.selectedNotification$,
      ).thenAnswer((_) => Stream.value(expectedNotification));

      final Stream<Notification?> pressedNotification$ = useCase.execute();

      expect(
        await pressedNotification$.first,
        expectedNotification,
      );
    },
  );
}
