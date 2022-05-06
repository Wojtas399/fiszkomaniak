import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
        onPressed: () => _save(context),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _FlashcardsState(),
          SizedBox(width: 16),
          _Timer(),
        ],
      ),
      actions: const [_DeleteIcon()],
    );
  }

  void _save(BuildContext context) {
    context.read<LearningProcessBloc>().add(LearningProcessEventSave());
  }
}

class _FlashcardsState extends StatelessWidget {
  const _FlashcardsState({Key? key}) : super(key: key);

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
    return Row(
      children: const [
        Icon(MdiIcons.clockOutline),
        SizedBox(width: 4),
        Text('13:21'),
      ],
    );
  }
}

class _DeleteIcon extends StatelessWidget {
  const _DeleteIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: MdiIcons.delete,
      onPressed: () {},
    );
  }
}
