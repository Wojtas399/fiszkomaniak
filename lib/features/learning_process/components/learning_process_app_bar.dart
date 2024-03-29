import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/custom_icon_button.dart';
import '../../../providers/dialogs_provider.dart';
import '../bloc/learning_process_bloc.dart';
import 'learning_process_timer.dart';

class LearningProcessAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const LearningProcessAppBar({super.key});

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
          _LeftMargin(),
          _StackState(),
          LearningProcessTimer(),
        ],
      ),
    );
  }

  Future<void> _exit(BuildContext context) async {
    final LearningProcessBloc learningProcessBloc =
        context.read<LearningProcessBloc>();
    final bool saveConfirmation = await _askForSaveConfirmation();
    learningProcessBloc.add(
      LearningProcessEventSessionAborted(
        doesUserWantToSaveProgress: saveConfirmation,
      ),
    );
  }

  Future<bool> _askForSaveConfirmation() async {
    return await DialogsProvider.askForConfirmation(
      title: 'Koniec sesji',
      text: 'Czy chcesz zapisać zmiany przed zakończeniem sesji?',
      confirmButtonText: 'Zapisz',
    );
  }
}

class _LeftMargin extends StatelessWidget {
  const _LeftMargin();

  @override
  Widget build(BuildContext context) {
    const bool isTimerInvisible = false;
    final Duration? duration = context.select(
      (LearningProcessBloc bloc) => bloc.state.duration,
    );
    return SizedBox(
      width: isTimerInvisible || duration == null ? 0.0 : 14.0,
    );
  }
}

class _StackState extends StatelessWidget {
  const _StackState();

  @override
  Widget build(BuildContext context) {
    final int indexOfDisplayedFlashcard = context.select(
      (LearningProcessBloc bloc) => bloc.state.indexOfDisplayedFlashcard,
    );
    final int amountOfFlashcardsInStack = context.select(
      (LearningProcessBloc bloc) => bloc.state.amountOfFlashcardsInStack,
    );
    return Text(
      '${indexOfDisplayedFlashcard + 1}/$amountOfFlashcardsInStack',
    );
  }
}
