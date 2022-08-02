import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/set_loss_of_days_streak_notification_use_case.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/providers/date_provider.dart';

class MockUserInterface extends Mock implements UserInterface {}

class MockNotificationsInterface extends Mock
    implements NotificationsInterface {}

class MockDateProvider extends Mock implements DateProvider {}

class FakeDate extends Fake implements Date {}

void main() {
  final userInterface = MockUserInterface();
  final notificationsInterface = MockNotificationsInterface();
  final dateProvider = MockDateProvider();
  late SetLossOfDaysStreakNotificationUseCase useCase;

  setUpAll(() {
    registerFallbackValue(FakeDate());
  });

  setUp(
    () => useCase = SetLossOfDaysStreakNotificationUseCase(
      userInterface: userInterface,
      notificationsInterface: notificationsInterface,
      dateProvider: dateProvider,
    ),
  );

  tearDown(() {
    reset(userInterface);
    reset(notificationsInterface);
    reset(dateProvider);
  });

  test(
    'should call method responsible for setting loss of days streak notification with tomorrow date if it is past nineteen today',
    () async {
      const Date tomorrowDate = Date(year: 2022, month: 5, day: 2);
      when(
        () => userInterface.daysStreak$,
      ).thenAnswer((_) => Stream.value(2));
      when(
        () => dateProvider.isAfterNineteenToday(),
      ).thenReturn(true);
      when(
        () => dateProvider.getTomorrowDate(),
      ).thenReturn(tomorrowDate);
      when(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: tomorrowDate,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: tomorrowDate,
        ),
      ).called(1);
    },
  );

  test(
    'should call method responsible for setting loss of days streak notification with today date if it is before nineteen today',
    () async {
      const Date todayDate = Date(year: 2022, month: 5, day: 1);
      when(
        () => userInterface.daysStreak$,
      ).thenAnswer((_) => Stream.value(2));
      when(
        () => dateProvider.isAfterNineteenToday(),
      ).thenReturn(false);
      when(
        () => dateProvider.getNow(),
      ).thenReturn(todayDate);
      when(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: todayDate,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: todayDate,
        ),
      ).called(1);
    },
  );

  test(
    'should not call method responsible for setting loss of days streak notification if days streak is equal to 0',
    () async {
      when(
        () => userInterface.daysStreak$,
      ).thenAnswer((_) => Stream.value(0));
      when(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: any(named: 'date'),
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verifyNever(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: any(named: 'date'),
        ),
      );
    },
  );
}
