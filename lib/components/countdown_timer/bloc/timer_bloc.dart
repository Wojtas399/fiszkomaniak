import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/components/countdown_timer/ticker.dart';

part 'timer_event.dart';

part 'timer_state.dart';

part 'timer_status.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  late final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({
    required Ticker ticker,
  }) : super(const TimerState()) {
    _ticker = ticker;
    on<TimerEventStart>(_start);
    on<TimerEventPause>(_pause);
    on<TimerEventResume>(_resume);
    on<TimerEventTicked>(_ticked);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _start(TimerEventStart event, Emitter<TimerState> emit) {
    emit(state.copyWith(
      duration: event.duration,
      status: TimerStatusRunInProgress(),
    ));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration.inSeconds)
        .listen((seconds) => add(TimerEventTicked(
              duration: Duration(seconds: seconds),
            )));
  }

  void _pause(TimerEventPause event, Emitter<TimerState> emit) {
    if (state.status is TimerStatusRunInProgress) {
      _tickerSubscription?.pause();
      emit(state.copyWith(status: TimerStatusRunPause()));
    }
  }

  void _resume(TimerEventResume event, Emitter<TimerState> emit) {
    if (state.status is TimerStatusRunPause) {
      _tickerSubscription?.resume();
      emit(state.copyWith(status: TimerStatusRunInProgress()));
    }
  }

  void _ticked(TimerEventTicked event, Emitter<TimerState> emit) {
    emit(state.copyWith(
      duration: event.duration,
      status: event.duration.inSeconds > 0
          ? TimerStatusRunInProgress()
          : TimerStatusRunComplete(),
    ));
  }
}
