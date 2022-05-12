part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileEventInitialize extends ProfileEvent {}

class ProfileEventUserUpdated extends ProfileEvent {
  final User? newUserData;

  ProfileEventUserUpdated({required this.newUserData});
}

class ProfileEventModifyAvatar extends ProfileEvent {}

class ProfileEventChangeUsername extends ProfileEvent {}

class ProfileEventChangePassword extends ProfileEvent {}
