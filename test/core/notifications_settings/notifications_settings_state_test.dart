import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late NotificationsSettingsState state;

  setUp(() {
    state = const NotificationsSettingsState();
  });

  test('initial state', () {
    expect(state.initializationStatus, InitializationStatus.loading);
    expect(state.areSessionsPlannedNotificationsOn, false);
    expect(state.areSessionsDefaultNotificationsOn, false);
    expect(state.areAchievementsNotificationsOn, false);
    expect(state.areDaysStreakLoseNotificationsOn, false);
    expect(state.httpStatus, const HttpStatusInitial());
  });

  test('copy with initialization status', () {
    const InitializationStatus status = InitializationStatus.ready;

    final state2 = state.copyWith(initializationStatus: status);
    final state3 = state2.copyWith();

    expect(state2.initializationStatus, status);
    expect(state3.initializationStatus, status);
  });

  test('copy with are sessions planned notifications on', () {
    final state2 = state.copyWith(areSessionsPlannedNotificationsOn: true);
    final state3 = state2.copyWith();

    expect(state2.areSessionsPlannedNotificationsOn, true);
    expect(state3.areSessionsPlannedNotificationsOn, true);
  });

  test('copy with are sessions default notifications on', () {
    final state2 = state.copyWith(areSessionsDefaultNotificationsOn: true);
    final state3 = state2.copyWith();

    expect(state2.areSessionsDefaultNotificationsOn, true);
    expect(state3.areSessionsDefaultNotificationsOn, true);
  });

  test('copy with are achievements notifications on', () {
    final state2 = state.copyWith(areAchievementsNotificationsOn: true);
    final state3 = state2.copyWith();

    expect(state2.areAchievementsNotificationsOn, true);
    expect(state3.areAchievementsNotificationsOn, true);
  });

  test('copy with are day streak lose notifications on', () {
    final state2 = state.copyWith(areDaysStreakLoseNotificationsOn: true);
    final state3 = state2.copyWith();

    expect(state2.areDaysStreakLoseNotificationsOn, true);
    expect(state3.areDaysStreakLoseNotificationsOn, true);
  });

  test('copy with http status', () {
    const HttpStatus status = HttpStatusSuccess();

    final state2 = state.copyWith(httpStatus: status);
    final state3 = state2.copyWith();

    expect(state2.httpStatus, status);
    expect(state3.httpStatus, const HttpStatusInitial());
  });
}
