import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flashcard_preview_info.dart';
import 'flashcard_preview_question_answer.dart';

class FlashcardPreviewContent extends StatelessWidget {
  const FlashcardPreviewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardPreviewBloc, FlashcardPreviewState>(
      builder: (BuildContext context, FlashcardPreviewState state) {
        if (state.flashcard == null) {
          return const Center(
            child: Text('The flashcard does not exist already'),
          );
        }
        return Column(
          children: const [
            FlashcardPreviewInfo(),
            SizedBox(height: 16),
            FlashcardPreviewQuestionAnswer(),
          ],
        );
      },
    );
  }
}
