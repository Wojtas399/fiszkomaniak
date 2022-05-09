import 'package:fiszkomaniak/components/countdown_timer/bloc/timer_bloc.dart';
import 'package:fiszkomaniak/components/countdown_timer/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountdownTimerProvider extends StatelessWidget {
  final Duration duration;
  final Widget child;

  const CountdownTimerProvider({
    Key? key,
    required this.duration,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker())
        ..add(TimerEventStart(duration: duration)),
      child: child,
    );
  }
}
