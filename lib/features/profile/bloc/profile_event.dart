part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileEventInitialize extends ProfileEvent {}

class ProfileEventLoggedUserAvatarUrlChanged extends ProfileEvent {
  final String newLoggedUserAvatarUrl;

  ProfileEventLoggedUserAvatarUrlChanged({
    required this.newLoggedUserAvatarUrl,
  });

  @override
  List<Object> get props => [newLoggedUserAvatarUrl];
}

class ProfileEventLoggedUserDataChanged extends ProfileEvent {
  final User newLoggedUserData;

  ProfileEventLoggedUserDataChanged({required this.newLoggedUserData});

  @override
  List<Object> get props => [newLoggedUserData];
}

class ProfileEventAchievementsStateUpdated extends ProfileEvent {
  final int daysStreak;
  final int allFlashcardsAmount;

  ProfileEventAchievementsStateUpdated({
    required this.daysStreak,
    required this.allFlashcardsAmount,
  });

  @override
  List<Object> get props => [daysStreak, allFlashcardsAmount];
}

class ProfileEventModifyAvatar extends ProfileEvent {}

class ProfileEventChangeUsername extends ProfileEvent {}

class ProfileEventChangePassword extends ProfileEvent {}

class ProfileEventSignOut extends ProfileEvent {}

class ProfileEventRemoveAccount extends ProfileEvent {}
