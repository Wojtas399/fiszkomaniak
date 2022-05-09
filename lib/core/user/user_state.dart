part of 'user_bloc.dart';

class UserState extends Equatable {
  final UserStatus status;
  final User? loggedUser;

  const UserState({
    this.status = const UserStatusInitial(),
    this.loggedUser,
  });

  UserState copyWith({
    UserStatus? status,
    User? loggedUser,
  }) {
    return UserState(
      status: status ?? UserStatusLoaded(),
      loggedUser: loggedUser ?? this.loggedUser,
    );
  }

  @override
  List<Object> get props => [
        status,
        loggedUser ?? '',
      ];
}
