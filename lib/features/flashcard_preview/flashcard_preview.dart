import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardPreview extends StatelessWidget {
  final String flashcardId;

  const FlashcardPreview({
    Key? key,
    required this.flashcardId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _FlashcardPreviewBlocProvider(
      flashcardId: flashcardId,
      child: const Scaffold(
        appBar: AppBarWithCloseButton(label: 'Fiszka'),
        body: Center(
          child: Text('flashcard preview'),
        ),
      ),
    );
  }
}

class _FlashcardPreviewBlocProvider extends StatelessWidget {
  final String flashcardId;
  final Widget child;

  const _FlashcardPreviewBlocProvider({
    Key? key,
    required this.flashcardId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FlashcardPreviewBloc(
        flashcardsBloc: context.read<FlashcardsBloc>(),
      )..add(FlashcardPreviewEventInitialize(flashcardId: flashcardId)),
      child: child,
    );
  }
}
