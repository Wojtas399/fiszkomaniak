import 'package:flutter/material.dart';

class LearningProcessFlashcards extends StatelessWidget {
  const LearningProcessFlashcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: const [
          _FlashcardTitle(),
          SizedBox(height: 8.0),
          Expanded(
            child: _Flashcard(),
          ),
        ],
      ),
    );
  }
}

class _FlashcardTitle extends StatelessWidget {
  const _FlashcardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Pytanie', style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(width: 4.0),
        Text(
          '(Angielski)',
          style: Theme.of(context).textTheme.bodyText2,
        )
      ],
    );
  }
}

class _Flashcard extends StatelessWidget {
  const _Flashcard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Wow'),
        ),
      ),
    );
  }
}
