import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AchievementsState state;

  setUp(() {
    state = const AchievementsState();
  });

  test('initial state', () {
    expect(state.status, const AchievementsStatusInitial());
    expect(state.daysStreak, 0);
    expect(state.allFlashcardsAmount, 0);
  });

  test('copy with status', () {
    final state2 = state.copyWith(
      status: const AchievementsStatusDaysStreakUpdated(newDaysStreak: 4),
    );
    final state3 = state2.copyWith();

    expect(
      state2.status,
      const AchievementsStatusDaysStreakUpdated(newDaysStreak: 4),
    );
    expect(state3.status, AchievementsStatusLoaded());
  });

  test('copy with days streak', () {
    const int daysStreak = 5;

    final state2 = state.copyWith(daysStreak: daysStreak);
    final state3 = state2.copyWith();

    expect(state2.daysStreak, daysStreak);
    expect(state3.daysStreak, daysStreak);
  });

  test('copy with all flashcards amount', () {
    const int allFlashcardsAmount = 200;

    final state2 = state.copyWith(allFlashcardsAmount: allFlashcardsAmount);
    final state3 = state2.copyWith();

    expect(state2.allFlashcardsAmount, allFlashcardsAmount);
    expect(state3.allFlashcardsAmount, allFlashcardsAmount);
  });
}
