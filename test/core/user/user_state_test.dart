import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UserState state;

  setUp(() {
    state = const UserState();
  });

  test('initial state', () {
    expect(state.initializationStatus, InitializationStatus.loading);
    expect(state.status, const UserStatusInitial());
    expect(state.loggedUser, null);
  });

  test('copy with initialization status', () {
    const InitializationStatus status = InitializationStatus.ready;

    final UserState state2 = state.copyWith(initializationStatus: status);
    final UserState state3 = state2.copyWith();

    expect(state2.initializationStatus, status);
    expect(state3.initializationStatus, status);
  });

  test('copy with status', () {
    final UserState state2 = state.copyWith(status: UserStatusLoading());
    final UserState state3 = state2.copyWith();

    expect(state2.status, UserStatusLoading());
    expect(state3.status, UserStatusLoaded());
  });

  test('copy with logged user', () {
    final User loggedUser = createUser(
      avatarUrl: 'avatar/url/image.jpg',
      days: [createDay(date: createDate(year: 2022))],
    );

    final UserState state2 = state.copyWith(loggedUser: loggedUser);
    final UserState state3 = state2.copyWith();

    expect(state2.loggedUser, loggedUser);
    expect(state3.loggedUser, loggedUser);
  });
}
