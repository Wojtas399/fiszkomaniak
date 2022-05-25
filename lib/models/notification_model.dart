import 'package:equatable/equatable.dart';

abstract class NotificationType extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationTypeSession extends NotificationType {
  final String sessionId;

  NotificationTypeSession({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class NotificationTypeDayStreakLose extends NotificationType {}
