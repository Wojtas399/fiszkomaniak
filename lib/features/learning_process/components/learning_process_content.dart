import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_status.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_buttons.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_end_options.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_flashcards.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_header.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../../../features/flashcards_stack/bloc/flashcards_stack_status.dart';

class LearningProcessContent extends StatelessWidget {
  const LearningProcessContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<LearningProcessBloc, LearningProcessState>(
        builder: (_, LearningProcessState state) {
          _updateFlashcardsStackStateAsNeeded(context, state);
          if (state.flashcards.isEmpty) {
            return const Center(
              child: Text('There is no flashcards'),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LearningProcessHeader(),
              const SizedBox(height: 16.0),
              Expanded(
                child: Stack(
                  children: const [
                    LearningProcessProgressBar(),
                    _FlashcardsStack(),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              const LearningProcessButtons(),
            ],
          );
        },
      ),
    );
  }

  void _updateFlashcardsStackStateAsNeeded(
    BuildContext context,
    LearningProcessState state,
  ) {
    if (state.status is LearningProcessStatusLoaded ||
        state.status is LearningProcessStatusReset) {
      context.read<FlashcardsStackBloc>().add(FlashcardsStackEventInitialize(
            flashcards: state.flashcardsToLearn,
          ));
    }
  }
}

class _FlashcardsStack extends StatelessWidget {
  const _FlashcardsStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FlashcardsStackStatus status = context.select(
      (FlashcardsStackBloc bloc) => bloc.state.status,
    );
    return status is FlashcardsStackStatusEnd
        ? const LearningProcessEndOptions()
        : const LearningProcessFlashcards();
  }
}
