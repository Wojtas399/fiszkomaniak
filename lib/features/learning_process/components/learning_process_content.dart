import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/components/flashcards_stack_bloc_provider.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_buttons.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_flashcards.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_header.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../../../features/flashcards_stack/bloc/flashcards_stack_status.dart';
import '../../../models/flashcard_model.dart';
import '../../flashcards_stack/bloc/flashcards_stack_models.dart';

class LearningProcessContent extends StatelessWidget {
  const LearningProcessContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningProcessBloc, LearningProcessState>(
      builder: (BuildContext context, LearningProcessState state) {
        if (state.flashcards.isEmpty) {
          return const Center(
            child: Text('There is no flashcards'),
          );
        }
        return FlashcardsStackBlocProvider(
          flashcards: _getBasicInfoOfFlashcards(state.flashcards),
          child: _FlashcardsStackListener(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LearningProcessHeader(),
                  SizedBox(height: 16.0),
                  LearningProcessFlashcards(),
                  SizedBox(height: 8.0),
                  LearningProcessProgressBar(),
                  SizedBox(height: 24.0),
                  LearningProcessButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<FlashcardInfo> _getBasicInfoOfFlashcards(List<Flashcard> flashcards) {
    return flashcards
        .map(
          (flashcard) => FlashcardInfo(
            id: flashcard.id,
            question: flashcard.question,
            answer: flashcard.answer,
          ),
        )
        .toList();
  }
}

class _FlashcardsStackListener extends StatelessWidget {
  final Widget child;

  const _FlashcardsStackListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlashcardsStackBloc, FlashcardsStackState>(
      listener: (BuildContext context, FlashcardsStackState state) {
        final FlashcardsStackStatus status = state.status;
        if (status is FlashcardsStackStatusMovedLeft) {
          context
              .read<LearningProcessBloc>()
              .add(LearningProcessEventForgottenFlashcard(
                flashcardId: status.flashcardId,
              ));
        } else if (status is FlashcardsStackStatusMovedRight) {
          context
              .read<LearningProcessBloc>()
              .add(LearningProcessEventRememberedFlashcard(
                flashcardId: status.flashcardId,
              ));
        }
      },
      child: child,
    );
  }
}
