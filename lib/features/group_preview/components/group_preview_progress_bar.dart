import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPreviewProgressBar extends StatelessWidget {
  const GroupPreviewProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupPreviewBloc, GroupPreviewState>(
      builder: (_, GroupPreviewState state) {
        return Section(
          title: 'Stan',
          child: Column(
            children: [
              const SizedBox(height: 8),
              FlashcardsProgressBar(
                amountOfRememberedFlashcards:
                    state.amountOfRememberedFlashcards,
                amountOfAllFlashcards: state.amountOfAllFlashcards,
                barHeight: 16,
              )
            ],
          ),
        );
      },
    );
  }
}
