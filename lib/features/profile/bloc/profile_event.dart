part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileEventInitialize extends ProfileEvent {}

class ProfileEventUserChanged extends ProfileEvent {
  final User user;

  ProfileEventUserChanged({required this.user});

  @override
  List<Object> get props => [user];
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

class ProfileEventChangeAvatar extends ProfileEvent {
  final String imagePath;

  ProfileEventChangeAvatar({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

class ProfileEventDeleteAvatar extends ProfileEvent {}

class ProfileEventChangeUsername extends ProfileEvent {
  final String newUsername;

  ProfileEventChangeUsername({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
}

class ProfileEventChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  ProfileEventChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class ProfileEventSignOut extends ProfileEvent {}

class ProfileEventDeleteAccount extends ProfileEvent {}
