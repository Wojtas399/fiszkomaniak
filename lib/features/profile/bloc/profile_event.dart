part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileEventInitialize extends ProfileEvent {}

class ProfileEventListenedParamsUpdated extends ProfileEvent {
  final ProfileStateListenedParams params;

  ProfileEventListenedParamsUpdated({required this.params});
}

class ProfileEventChangeAvatar extends ProfileEvent {
  final String imagePath;

  ProfileEventChangeAvatar({required this.imagePath});
}

class ProfileEventDeleteAvatar extends ProfileEvent {}

class ProfileEventChangeUsername extends ProfileEvent {
  final String newUsername;

  ProfileEventChangeUsername({required this.newUsername});
}

class ProfileEventChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  ProfileEventChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}

class ProfileEventSignOut extends ProfileEvent {}

class ProfileEventDeleteAccount extends ProfileEvent {
  final String password;

  ProfileEventDeleteAccount({required this.password});
}
