import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/settings.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';

void main() {
  late SettingsState state;

  setUp(
    () => state = const SettingsState(
      settings: Settings(
        appearanceSettings: AppearanceSettings(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: false,
          isSessionTimerInvisibilityOn: false,
        ),
        notificationsSettings: NotificationsSettings(
          areSessionsScheduledNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: false,
          areLossOfDaysStreakNotificationsOn: false,
        ),
      ),
      areAllNotificationsOn: false,
    ),
  );

  test(
    'appearance settings, should return appearance settings from settings',
    () {
      final AppearanceSettings expectedAppearanceSettings =
          createAppearanceSettings();

      state = state.copyWith(
        settings: createSettings(
          appearanceSettings: expectedAppearanceSettings,
        ),
      );

      expect(
        state.appearanceSettings,
        expectedAppearanceSettings,
      );
    },
  );

  test(
    'notifications settings, should return notifications settings from settings',
    () {
      final NotificationsSettings expectedNotificationsSettings =
          createNotificationsSettings();

      state = state.copyWith(
        settings: createSettings(
          notificationsSettings: expectedNotificationsSettings,
        ),
      );

      expect(
        state.notificationsSettings,
        expectedNotificationsSettings,
      );
    },
  );

  test(
    'copy with settings',
    () {
      final Settings expectedSettings = createSettings(
        appearanceSettings: createAppearanceSettings(
          isDarkModeOn: true,
          isSessionTimerInvisibilityOn: true,
        ),
        notificationsSettings: createNotificationsSettings(
          areSessionsScheduledNotificationsOn: true,
          areAchievementsNotificationsOn: true,
        ),
      );

      state = state.copyWith(settings: expectedSettings);
      final state2 = state.copyWith();

      expect(state.settings, expectedSettings);
      expect(state2.settings, expectedSettings);
    },
  );

  test(
    'copy with are all notifications on',
    () {
      const bool expectedValue = true;

      state = state.copyWith(areAllNotificationsOn: expectedValue);
      final state2 = state.copyWith();

      expect(state.areAllNotificationsOn, expectedValue);
      expect(state2.areAllNotificationsOn, expectedValue);
    },
  );
}
