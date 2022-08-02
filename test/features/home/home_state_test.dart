import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/features/home/bloc/home_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late HomeState state;

  setUp(
    () => state = const HomeState(
      status: BlocStatusInitial(),
      loggedUserAvatarUrl: '',
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
      daysStreak: 0,
    ),
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with logged user avatar url',
    () {
      const String expectedAvatarUrl = 'avatar/url';

      state = state.copyWith(loggedUserAvatarUrl: expectedAvatarUrl);
      final state2 = state.copyWith();

      expect(state.loggedUserAvatarUrl, expectedAvatarUrl);
      expect(state2.loggedUserAvatarUrl, expectedAvatarUrl);
    },
  );

  test(
    'copy with is dark mode on',
    () {
      const bool expectedValue = true;

      state = state.copyWith(isDarkModeOn: expectedValue);
      final state2 = state.copyWith();

      expect(state.isDarkModeOn, expectedValue);
      expect(state2.isDarkModeOn, expectedValue);
    },
  );

  test(
    'copy with is dark mode compatibility with system on',
    () {
      const bool expectedValue = true;

      state = state.copyWith(
        isDarkModeCompatibilityWithSystemOn: expectedValue,
      );
      final state2 = state.copyWith();

      expect(state.isDarkModeCompatibilityWithSystemOn, expectedValue);
      expect(state2.isDarkModeCompatibilityWithSystemOn, expectedValue);
    },
  );

  test(
    'copy with days streak',
    () {
      const int expectedDaysStreak = 12;

      state = state.copyWith(daysStreak: expectedDaysStreak);
      final state2 = state.copyWith();

      expect(state.daysStreak, expectedDaysStreak);
      expect(state2.daysStreak, expectedDaysStreak);
    },
  );
}
