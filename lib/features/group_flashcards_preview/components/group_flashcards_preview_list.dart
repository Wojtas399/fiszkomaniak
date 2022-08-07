import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/navigation.dart';
import 'group_flashcards_preview_item.dart';

class GroupFlashcardsPreviewList extends StatelessWidget {
  const GroupFlashcardsPreviewList({super.key});

  @override
  Widget build(BuildContext context) {
    final String groupId = context.select(
      (GroupFlashcardsPreviewBloc bloc) => bloc.state.groupId,
    );
    final List<Flashcard> flashcards = context.select(
      (GroupFlashcardsPreviewBloc bloc) => bloc.state.matchingFlashcards,
    );
    return Column(
      children: flashcards
          .map((flashcard) => _buildFlashcardItem(flashcard, groupId, context))
          .toList(),
    );
  }

  Widget _buildFlashcardItem(
    Flashcard flashcard,
    String groupId,
    BuildContext context,
  ) {
    return GroupFlashcardsPreviewItem(
      flashcard: flashcard,
      onTap: () => _showFlashcardDetails(groupId, flashcard.index, context),
    );
  }

  void _showFlashcardDetails(
    String groupId,
    int index,
    BuildContext context,
  ) {
    Navigation.navigateToFlashcardPreview(groupId, index);
  }
}
