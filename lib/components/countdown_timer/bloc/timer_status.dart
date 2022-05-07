part of 'timer_bloc.dart';

abstract class TimerStatus {
  const TimerStatus();
}

class TimerStatusInitial extends TimerStatus {
  const TimerStatusInitial();
}

class TimerStatusRunPause extends TimerStatus {}

class TimerStatusRunInProgress extends TimerStatus {}

class TimerStatusRunComplete extends TimerStatus {}
