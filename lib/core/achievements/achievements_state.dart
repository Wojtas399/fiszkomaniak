part of 'achievements_bloc.dart';

class AchievementsState extends Equatable {
  final AchievementsStatus status;
  final int daysStreak;
  final int allFlashcardsAmount;

  const AchievementsState({
    this.status = const AchievementsStatusInitial(),
    this.daysStreak = 0,
    this.allFlashcardsAmount = 0,
  });

  @override
  List<Object> get props => [
        status,
        daysStreak,
        allFlashcardsAmount,
      ];

  AchievementsState copyWith({
    AchievementsStatus? status,
    int? daysStreak,
    int? allFlashcardsAmount,
  }) {
    return AchievementsState(
      status: status ?? AchievementsStatusLoaded(),
      daysStreak: daysStreak ?? this.daysStreak,
      allFlashcardsAmount: allFlashcardsAmount ?? this.allFlashcardsAmount,
    );
  }
}

enum AchievementType {
  amountOfAllFlashcards,
  amountOfRememberedFlashcards,
  amountOfFinishedSessions,
}
