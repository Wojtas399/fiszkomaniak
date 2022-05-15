part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileEventInitialize extends ProfileEvent {}

class ProfileEventUserUpdated extends ProfileEvent {
  final User? newUserData;
  final int amountOfDaysInARow;

  ProfileEventUserUpdated({
    required this.newUserData,
    required this.amountOfDaysInARow,
  });
}

class ProfileEventFlashcardsStateUpdated extends ProfileEvent {
  final int amountOfAllFlashcards;

  ProfileEventFlashcardsStateUpdated({required this.amountOfAllFlashcards});
}

class ProfileEventModifyAvatar extends ProfileEvent {}

class ProfileEventChangeUsername extends ProfileEvent {}

class ProfileEventChangePassword extends ProfileEvent {}
