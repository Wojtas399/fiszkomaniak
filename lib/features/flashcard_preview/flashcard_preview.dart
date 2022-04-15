import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';

class FlashcardPreview extends StatelessWidget {
  final String flashcardId;

  const FlashcardPreview({
    Key? key,
    required this.flashcardId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithCloseButton(label: 'Fiszka'),
      body: Center(
        child: Text('flashcard preview'),
      ),
    );
  }
}
