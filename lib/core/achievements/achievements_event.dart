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
  final int newAmountOfAllFlashcards;

  AchievementsEventFlashcardsStateUpdated({
    required this.newAmountOfAllFlashcards,
  });

  @override
  List<Object> get props => [newAmountOfAllFlashcards];
}
