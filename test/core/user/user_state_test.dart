import 'package:fiszkomaniak/core/user/user_state.dart';
import 'package:fiszkomaniak/core/user/user_status.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UserState state;

  setUp(() {
    state = const UserState();
  });

  test('initial state', () {
    expect(state.status, const UserStatusInitial());
    expect(state.loggedUser, null);
  });

  test('copy with status', () {
    final UserState state2 = state.copyWith(status: UserStatusLoading());
    final UserState state3 = state2.copyWith();

    expect(state2.status, UserStatusLoading());
    expect(state3.status, UserStatusLoaded());
  });

  test('copy with logged user', () {
    final User loggedUser = createUser(
      days: [createDay(date: DateTime(2022))],
    );

    final UserState state2 = state.copyWith(loggedUser: loggedUser);
    final UserState state3 = state2.copyWith();

    expect(state2.loggedUser, loggedUser);
    expect(state3.loggedUser, loggedUser);
  });
}
