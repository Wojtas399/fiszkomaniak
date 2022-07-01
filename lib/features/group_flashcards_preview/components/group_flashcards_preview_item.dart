import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:flutter/material.dart';

class GroupFlashcardsPreviewItem extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback? onTap;

  const GroupFlashcardsPreviewItem({
    Key? key,
    required this.flashcard,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: IntrinsicHeight(
            child: Row(
              children: [
                _StatusColor(status: flashcard.status),
                _QuestionAndAnswer(
                  question: flashcard.question,
                  answer: flashcard.answer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusColor extends StatelessWidget {
  final FlashcardStatus status;

  const _StatusColor({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: status == FlashcardStatus.remembered ? Colors.green : Colors.red,
      width: 10,
      height: double.infinity,
    );
  }
}

class _QuestionAndAnswer extends StatelessWidget {
  final String question;
  final String answer;

  const _QuestionAndAnswer({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Text(text: question),
            const Divider(thickness: 1),
            _Text(text: answer),
          ],
        ),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  final String text;

  const _Text({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(text),
    );
  }
}
