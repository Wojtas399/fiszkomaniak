import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/day.dart';
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

  setUp(() {
    useCase = SetLossOfDaysStreakNotificationUseCase(
      userInterface: userInterface,
      notificationsInterface: notificationsInterface,
      dateProvider: dateProvider,
    );
    when(
      () => notificationsInterface.setLossOfDaysStreakNotification(
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => '');
  });

  tearDown(() {
    reset(userInterface);
    reset(notificationsInterface);
    reset(dateProvider);
  });

  test(
    'should call method responsible for setting loss of days streak notification with tomorrow date if user has already studied today',
    () async {
      const Date todayDate = Date(year: 2022, month: 5, day: 2);
      const Date tomorrowDate = Date(year: 2022, month: 5, day: 3);
      final List<Day> days = [
        createDay(date: const Date(year: 2022, month: 5, day: 1)),
        createDay(date: todayDate),
      ];
      when(
        () => userInterface.daysStreak$,
      ).thenAnswer((_) => Stream.value(2));
      when(
        () => userInterface.days$,
      ).thenAnswer((_) => Stream.value(days));
      when(
        () => dateProvider.getNow(),
      ).thenReturn(todayDate);
      when(
        () => dateProvider.getTomorrowDate(),
      ).thenReturn(tomorrowDate);

      await useCase.execute();

      verify(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: tomorrowDate,
        ),
      ).called(1);
    },
  );

  test(
    'should call method responsible for setting loss of days streak notification with today date if user has studied yesterday and now is before nineteen oclock',
    () async {
      const Date todayDate = Date(year: 2022, month: 5, day: 3);
      final List<Day> days = [
        createDay(date: const Date(year: 2022, month: 5, day: 1)),
        createDay(date: const Date(year: 2022, month: 5, day: 2)),
      ];
      when(
        () => userInterface.daysStreak$,
      ).thenAnswer((_) => Stream.value(1));
      when(
        () => userInterface.days$,
      ).thenAnswer((_) => Stream.value(days));
      when(
        () => dateProvider.isBeforeNineteenToday(),
      ).thenReturn(true);
      when(
        () => dateProvider.getNow(),
      ).thenReturn(todayDate);

      await useCase.execute();

      verify(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: todayDate,
        ),
      ).called(1);
    },
  );

  test(
    'should not call method responsible for setting loss of days streak notification with today date if user has studied yesterday but now is after nineteen oclock',
    () async {
      const Date todayDate = Date(year: 2022, month: 5, day: 3);
      final List<Day> days = [
        createDay(date: const Date(year: 2022, month: 5, day: 1)),
        createDay(date: const Date(year: 2022, month: 5, day: 2)),
      ];
      when(
        () => userInterface.daysStreak$,
      ).thenAnswer((_) => Stream.value(1));
      when(
        () => userInterface.days$,
      ).thenAnswer((_) => Stream.value(days));
      when(
        () => dateProvider.isBeforeNineteenToday(),
      ).thenReturn(false);
      when(
        () => dateProvider.getNow(),
      ).thenReturn(todayDate);

      await useCase.execute();

      verifyNever(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: todayDate,
        ),
      );
    },
  );

  test(
    'should not call method responsible for setting loss of days streak notification if days streak is equal to 0',
    () async {
      when(
        () => userInterface.daysStreak$,
      ).thenAnswer((_) => Stream.value(0));

      await useCase.execute();

      verifyNever(
        () => notificationsInterface.setLossOfDaysStreakNotification(
          date: any(named: 'date'),
        ),
      );
    },
  );
}
