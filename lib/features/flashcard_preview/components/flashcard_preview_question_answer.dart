import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'flashcard_preview_flashcard_with_title.dart';

class FlashcardPreviewQuestionAnswer extends StatelessWidget {
  const FlashcardPreviewQuestionAnswer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Question(),
          const SizedBox(height: 16),
          _Answer(),
        ],
      ),
    );
  }
}

class _Question extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final String? nameForQuestions = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.group?.nameForQuestions,
    );
    final String question = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.question,
    );
    final BlocStatus status = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.status,
    );
    if (_haveQuestionAndAnswerBeenInitialized(status) ||
        _haveQuestionAndAnswerBeenReset(status)) {
      _controller.text = question;
    }
    return FlashcardWithTitle(
      title: 'Pytanie',
      subtitle: nameForQuestions ?? '',
      controller: _controller,
      onChanged: (String question) => _onQuestionChanged(question, context),
      focusNode: _focusNode,
      onTap: () {
        _focusNode.requestFocus();
      },
    );
  }

  void _onQuestionChanged(
    String question,
    BuildContext context,
  ) {
    context
        .read<FlashcardPreviewBloc>()
        .add(FlashcardPreviewEventQuestionChanged(question: question));
  }

  bool _haveQuestionAndAnswerBeenInitialized(BlocStatus status) {
    return status is BlocStatusComplete &&
        status.info ==
            FlashcardPreviewInfoType.questionAndAnswerHaveBeenInitialized;
  }

  bool _haveQuestionAndAnswerBeenReset(BlocStatus status) {
    return status is BlocStatusComplete &&
        status.info == FlashcardPreviewInfoType.questionAndAnswerHaveBeenReset;
  }
}

class _Answer extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final String? nameForAnswers = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.group?.nameForAnswers,
    );
    final String answer = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.answer,
    );
    final BlocStatus status = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.status,
    );
    if (_haveQuestionAndAnswerBeenInitialized(status) ||
        _haveQuestionAndAnswerBeenReset(status)) {
      _controller.text = answer;
    }
    return FlashcardWithTitle(
      title: 'Odpowiedź',
      subtitle: nameForAnswers ?? '',
      controller: _controller,
      onChanged: (String answer) => _onAnswerChanged(answer, context),
      focusNode: _focusNode,
      onTap: () {
        _focusNode.requestFocus();
      },
    );
  }

  void _onAnswerChanged(
    String answer,
    BuildContext context,
  ) {
    context
        .read<FlashcardPreviewBloc>()
        .add(FlashcardPreviewEventAnswerChanged(answer: answer));
  }

  bool _haveQuestionAndAnswerBeenInitialized(BlocStatus status) {
    return status is BlocStatusComplete &&
        status.info ==
            FlashcardPreviewInfoType.questionAndAnswerHaveBeenInitialized;
  }

  bool _haveQuestionAndAnswerBeenReset(BlocStatus status) {
    return status is BlocStatusComplete &&
        status.info == FlashcardPreviewInfoType.questionAndAnswerHaveBeenReset;
  }
}
