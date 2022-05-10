part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User? userData;

  const ProfileState({this.userData});

  @override
  List<Object> get props => [userData ?? ''];

  ProfileState copyWith({
    User? userData,
  }) {
    return ProfileState(userData: userData ?? this.userData);
  }
}

enum AvatarActions {
  edit,
  delete,
}
