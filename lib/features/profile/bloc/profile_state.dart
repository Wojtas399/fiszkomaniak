part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User? loggedUserData;

  const ProfileState({this.loggedUserData});

  @override
  List<Object> get props => [loggedUserData ?? ''];

  ProfileState copyWith({
    User? loggedUserData,
  }) {
    return ProfileState(
      loggedUserData: loggedUserData ?? this.loggedUserData,
    );
  }
}

enum AvatarActions {
  edit,
  delete,
}
