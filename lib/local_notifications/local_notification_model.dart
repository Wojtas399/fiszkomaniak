import 'package:equatable/equatable.dart';

class LocalNotification extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalSessionNotification extends LocalNotification {
  final String sessionId;

  LocalSessionNotification({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class LocalLossOfDaysStreakNotification extends LocalNotification {}
