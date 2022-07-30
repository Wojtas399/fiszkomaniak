import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_days_streak_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final userInterface = MockUserInterface();
  final useCase = GetDaysStreakUseCase(userInterface: userInterface);

  test(
    'should return stream which contains amount of days in a row from today',
    () async {
      when(
        () => userInterface.daysStreak$,
      ).thenAnswer((_) => Stream.value(12));

      final Stream<int> daysStreak$ = useCase.execute();

      expect(await daysStreak$.first, 12);
    },
  );
}
