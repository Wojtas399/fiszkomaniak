import 'package:equatable/equatable.dart';

abstract class SessionCreatorStatus extends Equatable {
  const SessionCreatorStatus();

  @override
  List<Object> get props => [];
}

class SessionCreatorStatusInitial extends SessionCreatorStatus {
  const SessionCreatorStatusInitial();
}

class SessionCreatorStatusLoaded extends SessionCreatorStatus {}

class SessionCreatorStatusTimeFromThePast extends SessionCreatorStatus {}

class SessionCreatorStatusStartTimeEarlierThanNotificationTime
    extends SessionCreatorStatus {}

class SessionCreatorStatusNotificationTimeLaterThanStartTime
    extends SessionCreatorStatus {}
