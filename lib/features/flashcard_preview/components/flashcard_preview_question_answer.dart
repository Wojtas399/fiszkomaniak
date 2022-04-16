import 'package:fiszkomaniak/components/flashcard_multilines_text_field.dart';
import 'package:flutter/material.dart';

class FlashcardPreviewQuestionAnswer extends StatelessWidget {
  final String nameForQuestion;
  final String nameForAnswer;
  final TextEditingController questionController;
  final TextEditingController answerController;
  final Function(String value)? onQuestionChanged;
  final Function(String value)? onAnswerChanged;

  const FlashcardPreviewQuestionAnswer({
    Key? key,
    required this.nameForQuestion,
    required this.nameForAnswer,
    required this.questionController,
    required this.answerController,
    required this.onQuestionChanged,
    required this.onAnswerChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FlashcardToDisplay(
            title: 'Pytanie',
            subtitle: nameForQuestion,
            controller: questionController,
            onChanged: onQuestionChanged,
          ),
          const SizedBox(height: 16),
          _FlashcardToDisplay(
            title: 'Odpowiedź',
            subtitle: nameForAnswer,
            controller: answerController,
            onChanged: onAnswerChanged,
          ),
        ],
      ),
    );
  }
}

class _FlashcardToDisplay extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextEditingController controller;
  final Function(String value)? onChanged;

  const _FlashcardToDisplay({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FlashcardTitle(title: title, subtitle: subtitle),
        const SizedBox(height: 8),
        _Flashcard(controller: controller, onChanged: onChanged),
      ],
    );
  }
}

class _FlashcardTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FlashcardTitle({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(width: 4.0),
        Text('($subtitle)', style: Theme.of(context).textTheme.caption),
      ],
    );
  }
}

class _Flashcard extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final FocusNode focusNode = FocusNode();

  _Flashcard({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.requestFocus();
      },
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: FlashcardMultiLinesTextField(
                textAlign: TextAlign.center,
                controller: controller,
                onChanged: onChanged,
                focusNode: focusNode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
