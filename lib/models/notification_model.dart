import 'package:equatable/equatable.dart';

abstract class Notification extends Equatable {
  @override
  List<Object> get props => [];
}

class SessionNotification extends Notification {
  final String sessionId;

  SessionNotification({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class DaysStreakLoseNotification extends Notification {}
