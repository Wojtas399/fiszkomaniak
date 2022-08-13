part of 'timer_bloc.dart';

class TimerState extends Equatable {
  final TimerStatus status;
  final Duration duration;

  const TimerState({
    this.status = const TimerStatusInitial(),
    this.duration = const Duration(),
  });

  @override
  List<Object> get props => [
        status,
        duration,
      ];

  TimerState copyWith({
    TimerStatus? status,
    Duration? duration,
  }) {
    return TimerState(
      status: status ?? this.status,
      duration: duration ?? this.duration,
    );
  }
}
