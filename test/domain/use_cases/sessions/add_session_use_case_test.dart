import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/entities/settings.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/add_session_use_case.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

class MockGroupsInterface extends Mock implements GroupsInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

class MockSettingsInterface extends Mock implements SettingsInterface {}

class FakeTime extends Fake implements Time {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final groupsInterface = MockGroupsInterface();
  final notificationsInterface = MockNotificationsInterface();
  final settingsInterface = MockSettingsInterface();
  late AddSessionUseCase useCase;
  const String sessionId = 's1';
  const String groupId = 'g1';
  const String groupName = 'group name';
  const FlashcardsType flashcardsType = FlashcardsType.remembered;
  const bool areQuestionsAndAnswersSwapped = false;
  const Date date = Date(year: 2022, month: 1, day: 1);
  const Time startTime = Time(hour: 12, minute: 30);
  const Duration duration = Duration(minutes: 30);
  const Time notificationTime = Time(hour: 10, minute: 0);

  setUpAll(() {
    registerFallbackValue(FakeTime());
  });

  setUp(() {
    useCase = AddSessionUseCase(
      sessionsInterface: sessionsInterface,
      groupsInterface: groupsInterface,
      notificationsInterface: notificationsInterface,
      settingsInterface: settingsInterface,
    );
    when(
      () => sessionsInterface.addNewSession(
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      ),
    ).thenAnswer((_) async => sessionId);
    when(
      () => groupsInterface.getGroupName(groupId: groupId),
    ).thenAnswer((_) => Stream.value(groupName));
    when(
      () => notificationsInterface.setDefaultNotificationForSession(
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
  });

  tearDown(() {
    reset(sessionsInterface);
    reset(groupsInterface);
    reset(notificationsInterface);
    reset(settingsInterface);
  });

  test(
    'should call method responsible for adding new session',
    () async {
      when(
        () => settingsInterface.notificationsSettings$,
      ).thenAnswer(
        (_) => Stream.value(
          createNotificationsSettings(
            areSessionsScheduledNotificationsOn: false,
            areSessionsDefaultNotificationsOn: false,
          ),
        ),
      );

      await useCase.execute(
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      );

      verify(
        () => sessionsInterface.addNewSession(
          groupId: groupId,
          flashcardsType: flashcardsType,
          areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          date: date,
          startTime: startTime,
          duration: duration,
          notificationTime: notificationTime,
        ),
      ).called(1);
      verifyNever(
        () => notificationsInterface.setDefaultNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          sessionStartTime: startTime,
        ),
      );
      verifyNever(
        () => notificationsInterface.setScheduledNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          time: notificationTime,
          sessionStartTime: startTime,
        ),
      );
    },
  );

  test(
    'additionally should call method responsible for setting default notification if default notifications are turned on',
    () async {
      when(
        () => settingsInterface.notificationsSettings$,
      ).thenAnswer(
        (_) => Stream.value(
          createNotificationsSettings(
            areSessionsScheduledNotificationsOn: false,
            areSessionsDefaultNotificationsOn: true,
          ),
        ),
      );

      await useCase.execute(
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      );

      verify(
        () => notificationsInterface.setDefaultNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          sessionStartTime: startTime,
        ),
      ).called(1);
      verifyNever(
        () => notificationsInterface.setScheduledNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          time: notificationTime,
          sessionStartTime: startTime,
        ),
      );
    },
  );

  test(
    'additionally should call method responsible for setting scheduled notification if scheduled notifications are turned on and notification time is not null',
    () async {
      when(
        () => settingsInterface.notificationsSettings$,
      ).thenAnswer(
        (_) => Stream.value(
          createNotificationsSettings(
            areSessionsScheduledNotificationsOn: true,
            areSessionsDefaultNotificationsOn: false,
          ),
        ),
      );

      await useCase.execute(
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: notificationTime,
      );

      verifyNever(
        () => notificationsInterface.setDefaultNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          sessionStartTime: startTime,
        ),
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
    'should not call method responsible for setting scheduled notification if notification time is null',
    () async {
      when(
        () => sessionsInterface.addNewSession(
          groupId: groupId,
          flashcardsType: flashcardsType,
          areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          date: date,
          startTime: startTime,
          duration: duration,
          notificationTime: null,
        ),
      ).thenAnswer((_) async => sessionId);
      when(
        () => settingsInterface.notificationsSettings$,
      ).thenAnswer(
        (_) => Stream.value(
          createNotificationsSettings(
            areSessionsScheduledNotificationsOn: true,
            areSessionsDefaultNotificationsOn: false,
          ),
        ),
      );

      await useCase.execute(
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: date,
        startTime: startTime,
        duration: duration,
        notificationTime: null,
      );

      verifyNever(
        () => notificationsInterface.setScheduledNotificationForSession(
          sessionId: sessionId,
          groupName: groupName,
          date: date,
          time: any(named: 'time'),
          sessionStartTime: startTime,
        ),
      );
    },
  );
}
