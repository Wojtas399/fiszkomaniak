part of 'local_notifications_bloc.dart';

abstract class LocalNotificationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalNotificationsEventInitialize extends LocalNotificationsEvent {}

class LocalNotificationsEventSetNotification extends LocalNotificationsEvent {
  final String sessionId;
  final String groupName;
  final DateTime date;

  LocalNotificationsEventSetNotification({
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

class LocalNotificationsEventNotificationSelected
    extends LocalNotificationsEvent {
  final NotificationType type;

  LocalNotificationsEventNotificationSelected({required this.type});

  @override
  List<Object> get props => [type];
}
