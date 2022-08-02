import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/get_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsSettingsInterface extends Mock
    implements NotificationsSettingsInterface {}

void main() {
  final notificationsSettingsInterface = MockNotificationsSettingsInterface();
  final useCase = GetNotificationsSettingsUseCase(
    notificationsSettingsInterface: notificationsSettingsInterface,
  );

  test(
    'should return stream which contains notifications settings',
    () async {
      const NotificationsSettings expectedSettings = NotificationsSettings(
        areSessionsPlannedNotificationsOn: false,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: false,
        areLossOfDaysStreakNotificationsOn: true,
      );
      when(
        () => notificationsSettingsInterface.notificationsSettings$,
      ).thenAnswer((_) => Stream.value(expectedSettings));

      final settings = await useCase.execute().first;

      expect(settings, expectedSettings);
    },
  );
}
