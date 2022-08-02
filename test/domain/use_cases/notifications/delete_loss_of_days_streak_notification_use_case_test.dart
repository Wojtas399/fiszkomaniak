import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/delete_loss_of_days_streak_notification_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

void main() {
  final notificationsInterface = MockNotificationsInterface();
  final useCase = DeleteLossOfDaysStreakNotificationUseCase(
    notificationsInterface: notificationsInterface,
  );

  test(
    'should call method responsible for deleting loss of days streak notification',
    () async {
      when(
        () => notificationsInterface.deleteLossOfDaysStreakNotification(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => notificationsInterface.deleteLossOfDaysStreakNotification(),
      ).called(1);
    },
  );
}
