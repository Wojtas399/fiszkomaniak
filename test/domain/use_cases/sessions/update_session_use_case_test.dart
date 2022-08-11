import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/settings.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/update_session_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/utils/time_utils.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

class MockGroupsInterface extends Mock implements GroupsInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

class MockSettingsInterface extends Mock implements SettingsInterface {}

class MockTimeUtils extends Mock implements TimeUtils {}

class FakeTime extends Fake implements Time {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final groupsInterface = MockGroupsInterface();
  final notificationsInterface = MockNotificationsInterface();
  final settingsInterface = MockSettingsInterface();
  final timeUtils = MockTimeUtils();
  late UpdateSessionUseCase useCase;
  const String sessionId = 's1';
  const String groupId = 'g1';
  const String groupName = 'group name';
  const Date date = Date(year: 2022, month: 1, day: 1);
  const Time startTime = Time(hour: 12, minute: 30);
  const Duration duration = Duration(minutes: 30);
  const Time notificationTime = Time(hour: 10, minute: 30);
  final Session updatedSession = createSession(
    id: sessionId,
    groupId: groupId,
    date: date,
    startTime: startTime,
    duration: duration,
    notificationTime: notificationTime,
  );

  setUpAll(() {
    registerFallbackValue(FakeTime());
  });

  setUp(() {
    useCase = UpdateSessionUseCase(
      sessionsInterface: sessionsInterface,
      groupsInterface: groupsInterface,
      notificationsInterface: notificationsInterface,
      settingsInterface: settingsInterface,
      timeUtils: timeUtils,
    );
    when(
      () => sessionsInterface.updateSession(
        sessionId: sessionId,
        groupId: groupId,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      ),
    ).thenAnswer((_) async => updatedSession);
    when(
      () => groupsInterface.getGroupName(groupId: groupId),
    ).thenAnswer((_) => Stream.value(groupName));
    when(
      () => settingsInterface.notificationsSettings$,
    ).thenAnswer((_) => Stream.value(createNotificationsSettings()));
    when(
      () => timeUtils.isPastTime(startTime.subtractMinutes(15), date),
    ).thenReturn(false);
    when(
      () => timeUtils.isNow(startTime.subtractMinutes(15), date),
    ).thenReturn(false);
    when(
      () =>
          notificationsInterface.setNotificationForSession15minBeforeStartTime(
        sessionId: sessionId,
        groupName: groupName,
        date: date,
        sessionStartTime: startTime,
      ),
    ).thenAnswer((_) async => '');
    when(
      () => notificationsInterface.setScheduledNotificationForSession(
        sessionId: sessionId,
        groupName: groupName,
        date: date,
        time: notificationTime,
        sessionStartTime: startTime,
      ),
    ).thenAnswer((_) async => '');
    when(
      () => notificationsInterface
          .deleteNotificationForSession15minBeforeStartTime(
        sessionId: sessionId,
      ),
    ).thenAnswer((_) async => '');
    when(
      () => notificationsInterface.deleteScheduledNotificationForSession(
        sessionId: sessionId,
      ),
    ).thenAnswer((_) async => '');
  });

  tearDown(() {
    reset(sessionsInterface);
    reset(groupsInterface);
    reset(notificationsInterface);
    reset(settingsInterface);
    reset(timeUtils);
  });

  test(
    'should call method responsible for updating session',
    () async {
      await useCase.execute(
        sessionId: sessionId,
        groupId: groupId,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      );

      verify(
        () => sessionsInterface.updateSession(
          sessionId: sessionId,
          groupId: groupId,
          date: date,
          startTime: startTime,
          duration: duration,
          notificationTime: notificationTime,
        ),
      ).called(1);
    },
  );

  test(
    'should call method responsible for deleting notification 15 min before start time if this time is from the past',
    () async {
      when(
        () => timeUtils.isPastTime(startTime.subtractMinutes(15), date),
      ).thenReturn(true);

      await useCase.execute(
        sessionId: sessionId,
        groupId: groupId,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      );

      verify(
        () => notificationsInterface
            .deleteNotificationForSession15minBeforeStartTime(
          sessionId: sessionId,
        ),
      ).called(1);
    },
  );

  test(
    'should call method responsible for deleting notification 15 min before start time if this time is from now',
    () async {
      when(
        () => timeUtils.isPastTime(startTime.subtractMinutes(15), date),
      ).thenReturn(true);

      await useCase.execute(
        sessionId: sessionId,
        groupId: groupId,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      );

      verify(
        () => notificationsInterface
            .deleteNotificationForSession15minBeforeStartTime(
          sessionId: sessionId,
        ),
      ).called(1);
    },
  );

  test(
    'should call method responsible for setting notification 15 min before start time if default notifications are turned on and time 15 min before start time is from future',
    () async {
      when(
        () => settingsInterface.notificationsSettings$,
      ).thenAnswer(
        (_) => Stream.value(createNotificationsSettings(
          areSessionsDefaultNotificationsOn: true,
        )),
      );

      await useCase.execute(
        sessionId: sessionId,
        groupId: groupId,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      );

      verify(
        () => notificationsInterface
            .setNotificationForSession15minBeforeStartTime(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          sessionStartTime: startTime,
        ),
      ).called(1);
    },
  );

  test(
    'should call method responsible for setting scheduled notification if scheduled notifications are turned on and notification time is not null',
    () async {
      when(
        () => settingsInterface.notificationsSettings$,
      ).thenAnswer(
        (_) => Stream.value(createNotificationsSettings(
          areSessionsScheduledNotificationsOn: true,
        )),
      );

      await useCase.execute(
        sessionId: sessionId,
        groupId: groupId,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      );

      verify(
        () => notificationsInterface.setScheduledNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          time: notificationTime,
          sessionStartTime: startTime,
        ),
      ).called(1);
    },
  );

  test(
    'should call method responsible for deleting scheduled notification if notification time is null or sessions scheduled notifications are turned off',
    () async {
      when(
        () => sessionsInterface.updateSession(
          sessionId: sessionId,
          groupId: groupId,
          date: date,
          startTime: startTime,
          duration: duration,
          notificationTime: null,
        ),
      ).thenAnswer(
        (_) async => createSession(
          id: sessionId,
          groupId: groupId,
          date: date,
          startTime: startTime,
          duration: duration,
          notificationTime: null,
        ),
      );

      await useCase.execute(
        sessionId: sessionId,
        groupId: groupId,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: null,
      );

      verify(
        () => notificationsInterface.deleteScheduledNotificationForSession(
          sessionId: sessionId,
        ),
      );
    },
  );
}
