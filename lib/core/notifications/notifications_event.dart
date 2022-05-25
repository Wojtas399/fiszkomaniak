part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationsEventInitialize extends NotificationsEvent {}

class NotificationsEventSetNotification extends NotificationsEvent {
  final String sessionId;
  final String groupName;
  final DateTime date;

  NotificationsEventSetNotification({
    required this.sessionId,
    required this.groupName,
    required this.date,
  });

  @override
  List<Object> get props => [
        sessionId,
        groupName,
        date,
      ];
}

class NotificationsEventNotificationSelected extends NotificationsEvent {
  final NotificationType type;

  NotificationsEventNotificationSelected({required this.type});

  @override
  List<Object> get props => [type];
}
