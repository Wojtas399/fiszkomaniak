import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/timer_bloc.dart';
import 'ticker.dart';

class CountdownTimerProvider extends StatelessWidget {
  final Duration duration;
  final Widget child;

  const CountdownTimerProvider({
    super.key,
    required this.duration,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(
        ticker: const Ticker(),
      )..add(TimerEventStart(duration: duration)),
      child: child,
    );
  }
}
