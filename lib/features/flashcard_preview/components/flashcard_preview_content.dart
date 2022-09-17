import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/on_tap_focus_lose_area.dart';
import '../../../domain/entities/flashcard.dart';
import '../bloc/flashcard_preview_bloc.dart';
import 'flashcard_preview_app_bar.dart';
import 'flashcard_preview_data.dart';

class FlashcardPreviewContent extends StatelessWidget {
  const FlashcardPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FlashcardPreviewAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: OnTapFocusLoseArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0,
                bottom: 24.0,
              ),
              child: _FlashcardInfo(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FlashcardInfo extends StatelessWidget {
  const _FlashcardInfo();

  @override
  Widget build(BuildContext context) {
    final Flashcard? flashcard = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.flashcard,
    );
    if (flashcard != null) {
      return const FlashcardPreviewData();
    }
    return const _InfoAboutLackOfFlashcard();
  }
}

class _InfoAboutLackOfFlashcard extends StatelessWidget {
  const _InfoAboutLackOfFlashcard();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This flashcard does not exist already'),
    );
  }
}
