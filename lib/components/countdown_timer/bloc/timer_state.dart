part of 'timer_bloc.dart';

class TimerState extends Equatable {
  final TimerStatus status;
  final Duration duration;

  const TimerState({
    this.status = const TimerStatusInitial(),
    this.duration = const Duration(),
  });

  TimerState copyWith({
    TimerStatus? status,
    Duration? duration,
  }) {
    return TimerState(
      status: status ?? this.status,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object> get props => [
        status,
        duration,
      ];
}
