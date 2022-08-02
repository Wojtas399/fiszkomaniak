import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SettingsState state;

  setUp(
    () => state = const SettingsState(
      appearanceSettings: AppearanceSettings(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
      notificationsSettings: NotificationsSettings(
        areSessionsPlannedNotificationsOn: false,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: false,
        areLossOfDaysStreakNotificationsOn: false,
      ),
      areAllNotificationsOn: false,
    ),
  );

  test(
    'copy with appearance settings',
    () {
      const AppearanceSettings expectedSettings = AppearanceSettings(
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: true,
      );

      final state2 = state.copyWith(appearanceSettings: expectedSettings);
      final state3 = state2.copyWith();

      expect(state2.appearanceSettings, expectedSettings);
      expect(state3.appearanceSettings, expectedSettings);
    },
  );

  test(
    'copy with notifications settings',
    () {
      const NotificationsSettings expectedSettings = NotificationsSettings(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: true,
        areLossOfDaysStreakNotificationsOn: false,
      );

      final state2 = state.copyWith(notificationsSettings: expectedSettings);
      final state3 = state2.copyWith();

      expect(state2.notificationsSettings, expectedSettings);
      expect(state3.notificationsSettings, expectedSettings);
    },
  );

  test(
    'copy with are all notifications on',
    () {
      const bool expectedValue = true;

      final state2 = state.copyWith(areAllNotificationsOn: expectedValue);
      final state3 = state2.copyWith();

      expect(state2.areAllNotificationsOn, expectedValue);
      expect(state3.areAllNotificationsOn, expectedValue);
    },
  );
}
