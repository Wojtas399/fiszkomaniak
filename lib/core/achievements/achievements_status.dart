part of 'achievements_bloc.dart';

abstract class AchievementsStatus extends Equatable {
  const AchievementsStatus();

  @override
  List<Object> get props => [];
}

class AchievementsStatusInitial extends AchievementsStatus {
  const AchievementsStatusInitial();
}

class AchievementsStatusLoaded extends AchievementsStatus {}

class AchievementsStatusDaysStreakUpdated extends AchievementsStatus {
  final int newDaysStreak;

  const AchievementsStatusDaysStreakUpdated({required this.newDaysStreak});

  @override
  List<Object> get props => [newDaysStreak];
}

class AchievementsStatusNewConditionCompleted extends AchievementsStatus {
  final AchievementType achievementType;
  final int completedConditionValue;

  const AchievementsStatusNewConditionCompleted({
    required this.achievementType,
    required this.completedConditionValue,
  });

  @override
  List<Object> get props => [achievementType, completedConditionValue];
}
