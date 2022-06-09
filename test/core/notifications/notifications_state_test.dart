import 'package:fiszkomaniak/core/notifications/notifications_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late NotificationsState state;

  setUp(() {
    state = const NotificationsState();
  });

  test('initial state', () {
    expect(state.status, const NotificationsStatusInitial());
    expect(state.areScheduledNotificationsOn, false);
    expect(state.areDefaultNotificationsOn, false);
    expect(state.areDaysStreakLoseNotificationsOn, false);
  });

  test('copy with status', () {
    final state2 = state.copyWith(
      status: NotificationsStatusDaysStreakLoseSelected(),
    );
    final state3 = state2.copyWith();

    expect(state2.status, NotificationsStatusDaysStreakLoseSelected());
    expect(state3.status, NotificationsStatusLoaded());
  });

  test('copy with are scheduled notifications on', () {
    final state2 = state.copyWith(areScheduledNotificationsOn: true);
    final state3 = state2.copyWith();

    expect(state2.areScheduledNotificationsOn, true);
    expect(state3.areScheduledNotificationsOn, true);
  });

  test('copy with are default notifications on', () {
    final state2 = state.copyWith(areDefaultNotificationsOn: true);
    final state3 = state2.copyWith();

    expect(state2.areDefaultNotificationsOn, true);
    expect(state3.areDefaultNotificationsOn, true);
  });

  test('copy with are days streak lose notifications on', () {
    final state2 = state.copyWith(areDaysStreakLoseNotificationsOn: true);
    final state3 = state2.copyWith();

    expect(state2.areDaysStreakLoseNotificationsOn, true);
    expect(state3.areDaysStreakLoseNotificationsOn, true);
  });
}
