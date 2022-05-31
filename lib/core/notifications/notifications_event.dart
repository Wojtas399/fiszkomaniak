part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationsEventInitialize extends NotificationsEvent {}

class NotificationsEventNotificationSelected extends NotificationsEvent {
  final Notification notification;

  NotificationsEventNotificationSelected({required this.notification});

  @override
  List<Object> get props => [notification];
}

class NotificationsEventTurnOnSessionsScheduledNotifications
    extends NotificationsEvent {}

class NotificationsEventTurnOffSessionsScheduledNotifications
    extends NotificationsEvent {}

class NotificationsEventTurnOnSessionsDefaultNotifications
    extends NotificationsEvent {}

class NotificationsEventTurnOffSessionsDefaultNotifications
    extends NotificationsEvent {}

class NotificationsEventErrorReceived extends NotificationsEvent {
  final String message;

  NotificationsEventErrorReceived({required this.message});

  @override
  List<Object> get props => [message];
}
