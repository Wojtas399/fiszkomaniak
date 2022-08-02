import 'package:fiszkomaniak/features/initial_home/bloc/initial_home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InitialHomeState state;

  setUp(
    () => state = const InitialHomeState(
      mode: InitialHomeMode.login,
      isUserLogged: false,
    ),
  );

  test(
    'copy with mode',
    () {
      const InitialHomeMode expectedMode = InitialHomeMode.register;

      state = state.copyWith(mode: expectedMode);
      final state2 = state.copyWith();

      expect(state.mode, expectedMode);
      expect(state2.mode, expectedMode);
    },
  );

  test(
    'copy with is user logged',
    () {
      const bool expectedValue = true;

      state = state.copyWith(isUserLogged: expectedValue);
      final state2 = state.copyWith();

      expect(state.isUserLogged, expectedValue);
      expect(state2.isUserLogged, expectedValue);
    },
  );
}
