import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardPreviewQuestionAnswer extends StatelessWidget {
  const FlashcardPreviewQuestionAnswer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardPreviewBloc, FlashcardPreviewState>(
      builder: (BuildContext context, FlashcardPreviewState state) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FlashcardToDisplay(
                title: 'Pytanie',
                subtitle: state.group?.nameForQuestions ?? '',
                text: state.flashcard?.question ?? '',
              ),
              const SizedBox(height: 16),
              _FlashcardToDisplay(
                title: 'Odpowiedź',
                subtitle: state.group?.nameForAnswers ?? '',
                text: state.flashcard?.answer ?? '',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FlashcardToDisplay extends StatelessWidget {
  final String title;
  final String subtitle;
  final String text;

  const _FlashcardToDisplay({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(width: 4.0),
            Text('($subtitle)', style: Theme.of(context).textTheme.caption),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 180,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(text),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
