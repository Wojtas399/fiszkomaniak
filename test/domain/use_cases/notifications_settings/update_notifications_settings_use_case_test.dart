import 'package:fiszkomaniak/domain/use_cases/notifications_settings/update_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsSettingsInterface extends Mock
    implements NotificationsSettingsInterface {}

void main() {
  final notificationsSettingsInterface = MockNotificationsSettingsInterface();
  final useCase = UpdateNotificationsSettingsUseCase(
    notificationsSettingsInterface: notificationsSettingsInterface,
  );

  test(
    'should call method responsible for updating notifications settings',
    () async {
      when(
        () => notificationsSettingsInterface.updateSettings(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: true,
          areAchievementsNotificationsOn: false,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        areSessionsPlannedNotificationsOn: false,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: false,
        areLossOfDaysStreakNotificationsOn: true,
      );

      verify(
        () => notificationsSettingsInterface.updateSettings(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: true,
          areAchievementsNotificationsOn: false,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      ).called(1);
    },
  );
}
