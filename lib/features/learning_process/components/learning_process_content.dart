import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../bloc/learning_process_bloc.dart';
import 'learning_process_buttons.dart';
import 'learning_process_end_options.dart';
import 'learning_process_flashcards.dart';
import 'learning_process_header.dart';
import 'learning_process_progress_bar.dart';
import 'learning_process_app_bar.dart';

class LearningProcessContent extends StatelessWidget {
  const LearningProcessContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: LearningProcessAppBar(),
      body: SafeArea(
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final int amountOfAllFlashcardsInGroup = context.select(
      (LearningProcessBloc bloc) => bloc.state.amountOfAllFlashcards,
    );
    if (amountOfAllFlashcardsInGroup == 0) {
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
