import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/components/group_flashcards_preview_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'group_flashcards_preview_app_bar.dart';

class GroupFlashcardsPreviewContent extends StatelessWidget {
  const GroupFlashcardsPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GroupFlashcardsPreviewAppBar(),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final bool doesGroupHaveFlashcards = context.select(
      (GroupFlashcardsPreviewBloc bloc) => bloc.state.doesGroupHaveFlashcards,
    );
    if (doesGroupHaveFlashcards) {
      return const _FlashcardsList();
    }
    return const _NoFlashcardsInfo();
  }
}

class _FlashcardsList extends StatelessWidget {
  const _FlashcardsList();

  @override
  Widget build(BuildContext context) {
    return const BouncingScroll(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: GroupFlashcardsPreviewList(),
        ),
      ),
    );
  }
}

class _NoFlashcardsInfo extends StatelessWidget {
  const _NoFlashcardsInfo();

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
