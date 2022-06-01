part of 'notifications_bloc.dart';

abstract class NotificationsStatus extends Equatable {
  const NotificationsStatus();

  @override
  List<Object> get props => [];
}

class NotificationsStatusInitial extends NotificationsStatus {
  const NotificationsStatusInitial();
}

class NotificationsStatusLoaded extends NotificationsStatus {}

class NotificationsStatusSessionSelected extends NotificationsStatus {
  final String sessionId;

  const NotificationsStatusSessionSelected({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class NotificationsStatusDaysStreakLoseSelected extends NotificationsStatus {}

class NotificationsStatusError extends NotificationsStatus {
  final String message;

  const NotificationsStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
