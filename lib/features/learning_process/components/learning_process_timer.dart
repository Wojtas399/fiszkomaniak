import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/countdown_timer/bloc/timer_bloc.dart';
import '../../../components/countdown_timer/countdown_timer.dart';
import '../../../components/countdown_timer/countdown_timer_provider.dart';
import '../../../components/custom_icon_button.dart';
import '../bloc/learning_process_bloc.dart';

class LearningProcessTimer extends StatelessWidget {
  const LearningProcessTimer({super.key});

  @override
  Widget build(BuildContext context) {
    const bool isTimerInvisible = false;
    final Duration? duration = context.select(
      (LearningProcessBloc bloc) => bloc.state.duration,
    );
    if (duration == null || isTimerInvisible) {
      return const SizedBox();
    }
    return CountdownTimerProvider(
      duration: duration,
      child: _TimerListener(
        child: Row(
          children: const [
            SizedBox(width: 24.0),
            Icon(MdiIcons.clockOutline),
            SizedBox(width: 4.0),
            CountdownTimer(),
            _StopResumeButton(),
          ],
        ),
      ),
    );
  }
}

class _TimerListener extends StatelessWidget {
  final Widget child;

  const _TimerListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerBloc, TimerState>(
      listener: (BuildContext context, TimerState state) {
        if (state.status is TimerStatusRunComplete) {
          _onTimeFinished(context);
        }
      },
      child: child,
    );
  }

  void _onTimeFinished(BuildContext context) {
    context.read<LearningProcessBloc>().add(LearningProcessEventTimeFinished());
  }
}

class _StopResumeButton extends StatelessWidget {
  const _StopResumeButton();

  @override
  Widget build(BuildContext context) {
    final TimerStatus timerStatus = context.select(
      (TimerBloc bloc) => bloc.state.status,
    );
    if (timerStatus is TimerStatusRunInProgress) {
      return CustomIconButton(
        icon: MdiIcons.pause,
        onPressed: () => _pause(context),
      );
    } else if (timerStatus is TimerStatusRunPause) {
      return CustomIconButton(
        icon: MdiIcons.play,
        onPressed: () => _resume(context),
      );
    }
    return const SizedBox();
  }

  void _pause(BuildContext context) {
    context.read<TimerBloc>().add(TimerEventPause());
  }

  void _resume(BuildContext context) {
    context.read<TimerBloc>().add(TimerEventResume());
  }
}
