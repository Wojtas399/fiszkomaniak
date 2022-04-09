import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/components/flashcards_editor_app_bar.dart';
import 'package:fiszkomaniak/features/flashcards_editor/components/flashcards_editor_flashcard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardsEditor extends StatelessWidget {
  final String groupId;

  const FlashcardsEditor({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _FlashcardsEditorBlocProvider(
      groupId: groupId,
      child: Scaffold(
        appBar: const FlashcardsEditorAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: OnTapFocusLoseArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: const [
                    FlashcardsEditorFlashcardItem(
                      nameForQuestion: 'Angielski',
                      nameForAnswer: 'Polski',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FlashcardsEditorBlocProvider extends StatelessWidget {
  final String groupId;
  final Widget child;

  const _FlashcardsEditorBlocProvider({
    Key? key,
    required this.groupId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FlashcardsEditorBloc(
        groupsBloc: context.read<GroupsBloc>(),
      )..add(FlashcardsEditorEventInitialize(groupId: groupId)),
      child: child,
    );
  }
}
