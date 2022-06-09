part of 'achievements_bloc.dart';

abstract class AchievementsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AchievementsEventInitialize extends AchievementsEvent {}

class AchievementsEventUserStateUpdated extends AchievementsEvent {
  final User? updatedLoggedUser;

  AchievementsEventUserStateUpdated({required this.updatedLoggedUser});

  @override
  List<Object> get props => [updatedLoggedUser ?? ''];
}

class AchievementsEventFlashcardsStateUpdated extends AchievementsEvent {
  final int amountOfAllFlashcards;

  AchievementsEventFlashcardsStateUpdated({
    required this.amountOfAllFlashcards,
  });

  @override
  List<Object> get props => [
        amountOfAllFlashcards,
      ];
}

class AchievementsEventNewConditionAchieved extends AchievementsEvent {
  final AchievementType achievementType;
  final int completedConditionValue;

  AchievementsEventNewConditionAchieved({
    required this.achievementType,
    required this.completedConditionValue,
  });

  @override
  List<Object> get props => [achievementType, completedConditionValue];
}

class AchievementsEventAddNewFlashcards extends AchievementsEvent {
  final String groupId;
  final List<int> flashcardsIndexes;

  AchievementsEventAddNewFlashcards({
    required this.groupId,
    required this.flashcardsIndexes,
  });

  @override
  List<Object> get props => [groupId, flashcardsIndexes];
}

class AchievementsEventAddRememberedFlashcards extends AchievementsEvent {
  final String groupId;
  final List<int> rememberedFlashcardsIndexes;

  AchievementsEventAddRememberedFlashcards({
    required this.groupId,
    required this.rememberedFlashcardsIndexes,
  });

  @override
  List<Object> get props => [groupId, rememberedFlashcardsIndexes];
}

class AchievementsEventAddSession extends AchievementsEvent {
  final String? sessionId;

  AchievementsEventAddSession({required this.sessionId});

  @override
  List<Object> get props => [sessionId ?? ''];
}
