import 'package:fiszkomaniak/components/countdown_timer/countdown_timer_provider.dart';
import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/countdown_timer/bloc/timer_bloc.dart';
import '../../../components/countdown_timer/countdown_timer.dart';

class LearningProcessAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const LearningProcessAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CustomIconButton(
        icon: MdiIcons.arrowLeft,
        onPressed: () => _exit(context),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(width: 24.0),
          _StackState(),
          _Timer(),
        ],
      ),
    );
  }

  void _exit(BuildContext context) {
    context.read<LearningProcessBloc>().add(LearningProcessEventExit());
  }
}

class _StackState extends StatelessWidget {
  const _StackState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningProcessBloc, LearningProcessState>(
      builder: (_, LearningProcessState state) {
        return Text(
          '${state.indexOfDisplayedFlashcard + 1}/${state.amountOfFlashcardsInStack}',
        );
      },
    );
  }
}

class _Timer extends StatelessWidget {
  const _Timer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTimerInvisible = context.select(
      (AppearanceSettingsBloc bloc) => bloc.state.isSessionTimerInvisibilityOn,
    );
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
            SizedBox(width: 16.0),
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

  const _TimerListener({Key? key, required this.child}) : super(key: key);

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
  const _StopResumeButton({Key? key}) : super(key: key);

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
