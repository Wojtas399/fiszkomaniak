part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsStateInitial extends NotificationsState {
  const NotificationsStateInitial();
}

class NotificationsStateLoaded extends NotificationsState {}

class NotificationsStateSessionSelected extends NotificationsState {
  final String sessionId;

  const NotificationsStateSessionSelected({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class NotificationsStateError extends NotificationsState {
  final String message;

  const NotificationsStateError({required this.message});

  @override
  List<Object> get props => [message];
}
