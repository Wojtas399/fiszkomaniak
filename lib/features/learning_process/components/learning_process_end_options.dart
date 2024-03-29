import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/button.dart';
import '../../../components/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../../../domain/entities/session.dart';
import '../../../ui_extensions/flashcards_type_converters.dart';
import '../bloc/learning_process_bloc.dart';

class LearningProcessEndOptions extends StatelessWidget {
  const LearningProcessEndOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      bottom: 48.0,
      left: 24.0,
      right: 24.0,
      child: Center(
        child: BlocSelector<LearningProcessBloc, LearningProcessState, bool>(
          selector: (LearningProcessState state) {
            return state.areAllFlashcardsRememberedOrNotRemembered;
          },
          builder: (_, bool areAllFlashcardsRememberedOrNotRemembered) {
            return areAllFlashcardsRememberedOrNotRemembered
                ? const _ResetButton()
                : const _FlashcardsTypeOptions();
          },
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Button(
        label: 'Od nowa',
        onPressed: () => _reset(context),
      ),
    );
  }

  void _reset(BuildContext context) {
    context
        .read<LearningProcessBloc>()
        .add(LearningProcessEventReset(newFlashcardsType: FlashcardsType.all));
    context.read<FlashcardsStackBloc>().add(FlashcardsStackEventReset());
  }
}

class _FlashcardsTypeOptions extends StatelessWidget {
  const _FlashcardsTypeOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Wybierz rodzaj fiszek do dalszej nauki:',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        ..._buildButtons(context),
      ],
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return FlashcardsType.values
        .map(
          (type) => Column(
            children: [
              const SizedBox(height: 24.0),
              Button(
                label: convertFlashcardsTypeToViewFormat(type),
                onPressed: () => _onTypeSelected(context, type),
              ),
            ],
          ),
        )
        .toList();
  }

  void _onTypeSelected(BuildContext context, FlashcardsType type) {
    context
        .read<LearningProcessBloc>()
        .add(LearningProcessEventReset(newFlashcardsType: type));
    context.read<FlashcardsStackBloc>().add(FlashcardsStackEventReset());
  }
}
