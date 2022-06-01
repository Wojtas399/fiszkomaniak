part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileEventInitialize extends ProfileEvent {}

class ProfileEventUserStateUpdated extends ProfileEvent {
  final User? newUserData;

  ProfileEventUserStateUpdated({required this.newUserData});
}

class ProfileEventAchievementsStateUpdated extends ProfileEvent {
  final int daysStreak;
  final int allFlashcardsAmount;

  ProfileEventAchievementsStateUpdated({
    required this.daysStreak,
    required this.allFlashcardsAmount,
  });
}

class ProfileEventModifyAvatar extends ProfileEvent {}

class ProfileEventChangeUsername extends ProfileEvent {}

class ProfileEventChangePassword extends ProfileEvent {}

class ProfileEventSignOut extends ProfileEvent {}

class ProfileEventRemoveAccount extends ProfileEvent {}
