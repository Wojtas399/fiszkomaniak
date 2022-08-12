import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/timer_bloc.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final Duration duration = context.select(
      (TimerBloc bloc) => bloc.state.duration,
    );
    final String minutes = _twoDigits(duration.inMinutes.remainder(60));
    final String seconds = _twoDigits(duration.inSeconds.remainder(60));
    String durationStr = '$minutes:$seconds';
    double width = 65.0;
    if (duration.inHours > 0) {
      durationStr = '${_twoDigits(duration.inHours)}:$durationStr';
      width = 95.0;
    }
    return SizedBox(
      width: width,
      child: Text(durationStr),
    );
  }

  String _twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}
