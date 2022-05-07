import 'package:fiszkomaniak/components/countdown_timer/countdown_timer_provider.dart';
import 'package:fiszkomaniak/components/custom_icon_button.dart';
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
    final Duration? duration = context.select(
      (LearningProcessBloc bloc) => bloc.state.data?.duration,
    );
    if (duration == null) {
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
          //TODO
        }
      },
      child: child,
    );
  }
}
