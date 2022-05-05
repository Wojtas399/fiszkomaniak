import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_event.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/components/flashcards_stack_bloc_provider.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
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
    return FlashcardsStackBlocProvider(
      child: BlocBuilder<LearningProcessBloc, LearningProcessState>(
        builder: (BuildContext context, LearningProcessState state) {
          _updateFlashcardsStackStateAsNeeded(context, state);
          if (state.flashcards.isEmpty) {
            return const Center(
              child: Text('There is no flashcards'),
            );
          }
          return BlocConsumer<FlashcardsStackBloc, FlashcardsStackState>(
            listener: (BuildContext context, FlashcardsStackState state) {
              final FlashcardsStackStatus status = state.status;
              if (status is FlashcardsStackStatusMovedLeft) {
                _forgottenFlashcard(context, status.flashcardIndex);
              } else if (status is FlashcardsStackStatusMovedRight) {
                _rememberedFlashcard(context, status.flashcardIndex);
              }
            },
            builder: (_, FlashcardsStackState state) {
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LearningProcessHeader(),
                    const SizedBox(height: 16.0),
                    state.status is FlashcardsStackStatusEnd
                        ? const LearningProcessEndOptions()
                        : const LearningProcessFlashcards(),
                    const SizedBox(height: 8.0),
                    const LearningProcessProgressBar(),
                    const SizedBox(height: 24.0),
                    const LearningProcessButtons(),
                  ],
                ),
              );
            },
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

  void _forgottenFlashcard(BuildContext context, int flashcardIndex) {
    context
        .read<LearningProcessBloc>()
        .add(LearningProcessEventForgottenFlashcard(
          flashcardIndex: flashcardIndex,
        ));
  }

  void _rememberedFlashcard(BuildContext context, int flashcardIndex) {
    context
        .read<LearningProcessBloc>()
        .add(LearningProcessEventRememberedFlashcard(
          flashcardIndex: flashcardIndex,
        ));
  }
}
