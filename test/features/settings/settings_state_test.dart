import 'package:fiszkomaniak/features/settings/bloc/settings_state.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SettingsState state;

  setUp(() {
    state = const SettingsState();
  });

  test('initial state', () {
    expect(
      state.appearanceSettings,
      const AppearanceSettings(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
    );
    expect(
      state.notificationsSettings,
      const NotificationsSettings(
        areSessionsPlannedNotificationsOn: false,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: false,
        areDaysStreakLoseNotificationsOn: false,
      ),
    );
    expect(state.areAllNotificationsOn, false);
  });

  test('copy with appearance settings', () {
    const AppearanceSettings settings = AppearanceSettings(
      isDarkModeOn: true,
      isDarkModeCompatibilityWithSystemOn: false,
      isSessionTimerInvisibilityOn: true,
    );

    final state2 = state.copyWith(appearanceSettings: settings);
    final state3 = state2.copyWith();

    expect(state2.appearanceSettings, settings);
    expect(state3.appearanceSettings, settings);
  });

  test('copy with notifications settings', () {
    const NotificationsSettings settings = NotificationsSettings(
      areSessionsPlannedNotificationsOn: true,
      areSessionsDefaultNotificationsOn: true,
      areAchievementsNotificationsOn: false,
      areDaysStreakLoseNotificationsOn: false,
    );

    final state2 = state.copyWith(notificationsSettings: settings);
    final state3 = state2.copyWith();

    expect(state2.notificationsSettings, settings);
    expect(state3.notificationsSettings, settings);
  });

  test('copy with are all notifications on', () {
    final state2 = state.copyWith(areAllNotificationsOn: true);
    final state3 = state2.copyWith();

    expect(state2.areAllNotificationsOn, true);
    expect(state3.areAllNotificationsOn, true);
  });
}
