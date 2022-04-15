import 'package:fiszkomaniak/features/flashcards_preview/components/flashcards_preview_app_bar.dart';
import 'package:flutter/material.dart';

class FlashcardsPreview extends StatelessWidget {
  final String groupId;

  const FlashcardsPreview({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FlashcardsPreviewAppBar(),
      body: Center(
        child: Text('Flashcards preview'),
      ),
    );
  }
}
