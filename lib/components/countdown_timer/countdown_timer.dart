import 'package:fiszkomaniak/components/countdown_timer/bloc/timer_bloc.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Duration duration = context.select(
      (TimerBloc bloc) => bloc.state.duration,
    );
    final String minutes = Utils.twoDigits(duration.inMinutes.remainder(60));
    final String seconds = Utils.twoDigits(duration.inSeconds.remainder(60));
    String durationStr = '$minutes:$seconds';
    double width = 65.0;
    if (duration.inHours > 0) {
      durationStr = '${Utils.twoDigits(duration.inHours)}:$durationStr';
      width = 95.0;
    }
    return SizedBox(
      width: width,
      child: Text(durationStr),
    );
  }
}
