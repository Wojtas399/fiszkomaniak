import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/list_view_fade_animated_item.dart';
import '../../../config/navigation.dart';
import '../../../domain/entities/flashcard.dart';
import '../bloc/group_flashcards_preview_bloc.dart';
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
    return ListView.builder(
      cacheExtent: 0,
      padding: const EdgeInsets.all(24),
      itemCount: flashcards.length,
      itemBuilder: (_, int index) {
        return ListViewFadeAnimatedItem(
          child: GroupFlashcardsPreviewItem(
            flashcard: flashcards[index],
            onTap: () => _showFlashcardDetails(groupId, index, context),
          ),
        );
      },
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
