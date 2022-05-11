part of 'user_bloc.dart';

abstract class UserStatus extends Equatable {
  const UserStatus();

  @override
  List<Object> get props => [];
}

class UserStatusInitial extends UserStatus {
  const UserStatusInitial();
}

class UserStatusLoaded extends UserStatus {}

class UserStatusLoading extends UserStatus {}

class UserStatusNewAvatarSaved extends UserStatus {}

class UserStatusAvatarRemoved extends UserStatus {}

class UserStatusUsernameUpdated extends UserStatus {}

class UserStatusNewRememberedFlashcardsSaved extends UserStatus {}

class UserStatusError extends UserStatus {
  final String message;

  const UserStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
