part of 'timer_bloc.dart';

abstract class TimerEvent {}

class TimerEventStart extends TimerEvent {
  final Duration duration;

  TimerEventStart({required this.duration});
}

class TimerEventPause extends TimerEvent {}

class TimerEventResume extends TimerEvent {}

class TimerEventTicked extends TimerEvent {
  final Duration duration;

  TimerEventTicked({required this.duration});
}
