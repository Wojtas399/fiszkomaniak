import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/flashcard.dart';
import 'flashcard_preview_info.dart';
import 'flashcard_preview_question_answer.dart';

class FlashcardPreviewContent extends StatelessWidget {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _questionFocusNode = FocusNode();
  final FocusNode _answerFocusNode = FocusNode();

  FlashcardPreviewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardPreviewBloc, FlashcardPreviewState>(
      builder: (BuildContext context, FlashcardPreviewState state) {
        if (state.status is FlashcardPreviewStatusLoaded ||
            state.status is FlashcardPreviewStatusReset) {
          _questionController.text = state.flashcard?.question ?? '';
          _answerController.text = state.flashcard?.answer ?? '';
        }
        final Flashcard? flashcard = state.flashcard;
        if (flashcard == null) {
          return const Center(
            child: Text('The flashcard does not exist already'),
          );
        }
        return Column(
          children: [
            const FlashcardPreviewInfo(),
            const SizedBox(height: 16),
            FlashcardPreviewQuestionAnswer(
              nameForQuestion: state.group?.nameForQuestions ?? '',
              nameForAnswer: state.group?.nameForAnswers ?? '',
              questionController: _questionController,
              answerController: _answerController,
              questionFocusNode: _questionFocusNode,
              answerFocusNode: _answerFocusNode,
              onQuestionChanged: (String value) {
                context
                    .read<FlashcardPreviewBloc>()
                    .add(FlashcardPreviewEventQuestionChanged(question: value));
              },
              onAnswerChanged: (String value) {
                context
                    .read<FlashcardPreviewBloc>()
                    .add(FlashcardPreviewEventAnswerChanged(answer: value));
              },
            ),
          ],
        );
      },
    );
  }
}
