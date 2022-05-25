part of 'local_notifications_bloc.dart';

abstract class LocalNotificationsState extends Equatable {
  const LocalNotificationsState();

  @override
  List<Object> get props => [];
}

class LocalNotificationsStateInitial extends LocalNotificationsState {
  const LocalNotificationsStateInitial();
}

class LocalNotificationsStateLoaded extends LocalNotificationsState {}

class LocalNotificationsStateSessionSelected extends LocalNotificationsState {
  final String sessionId;

  const LocalNotificationsStateSessionSelected({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class LocalNotificationsStateError extends LocalNotificationsState {
  final String message;

  const LocalNotificationsStateError({required this.message});

  @override
  List<Object> get props => [message];
}
