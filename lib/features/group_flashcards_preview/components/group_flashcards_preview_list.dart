import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_state.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/components/group_flashcards_preview_item.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupFlashcardsPreviewList extends StatelessWidget {
  const GroupFlashcardsPreviewList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFlashcardsPreviewBloc, GroupFlashcardsPreviewState>(
      builder: (BuildContext context, GroupFlashcardsPreviewState state) {
        if (state.flashcardsFromGroup.isEmpty) {
          return const _NoFlashcardsInfo();
        }
        return BouncingScroll(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: state.matchingFlashcards
                    .map((flashcard) => _generateItem(context, flashcard))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _generateItem(BuildContext context, Flashcard flashcard) {
    return GroupFlashcardsPreviewItem(
      flashcard: flashcard,
      onTap: () {
        context
            .read<GroupFlashcardsPreviewBloc>()
            .add(GroupFlashcardsPreviewEventShowFlashcardDetails(
              flashcardId: flashcard.id,
            ));
      },
    );
  }
}

class _NoFlashcardsInfo extends StatelessWidget {
  const _NoFlashcardsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: EmptyContentInfo(
            icon: MdiIcons.cards,
            title: 'Brak fiszek w grupie',
            subtitle: 'Dodaj fiszki do grupy aby móc je przeglądać',
          ),
        ),
      ),
    );
  }
}
