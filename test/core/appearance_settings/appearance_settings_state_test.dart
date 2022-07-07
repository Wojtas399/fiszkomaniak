import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppearanceSettingsState state;

  setUp(
    () => state = const AppearanceSettingsState(
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
      isSessionTimerInvisibilityOn: false,
    ),
  );

  test(
    'copy with is dark mode on',
    () {
      const bool expectedValue = true;

      final state2 = state.copyWith(isDarkModeOn: expectedValue);
      final state3 = state2.copyWith();

      expect(state2.isDarkModeOn, expectedValue);
      expect(state3.isDarkModeOn, expectedValue);
    },
  );

  test(
    'copy with is dark mode compatibility with system on on',
    () {
      const bool expectedValue = true;

      final state2 = state.copyWith(
        isDarkModeCompatibilityWithSystemOn: expectedValue,
      );
      final state3 = state2.copyWith();

      expect(state2.isDarkModeCompatibilityWithSystemOn, expectedValue);
      expect(state3.isDarkModeCompatibilityWithSystemOn, expectedValue);
    },
  );

  test(
    'copy with is session timer invisibility on',
    () {
      const bool expectedValue = true;

      final state2 = state.copyWith(
        isSessionTimerInvisibilityOn: expectedValue,
      );
      final state3 = state2.copyWith();

      expect(state2.isSessionTimerInvisibilityOn, expectedValue);
      expect(state3.isSessionTimerInvisibilityOn, expectedValue);
    },
  );
}
