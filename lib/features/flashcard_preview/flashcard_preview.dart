import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_event.dart';
import 'package:fiszkomaniak/features/flashcard_preview/components/flashcard_preview_app_bar.dart';
import 'package:fiszkomaniak/features/flashcard_preview/components/flashcard_preview_content.dart';
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
        appBar: FlashcardPreviewAppBar(),
        body: BouncingScroll(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0,
                bottom: 24.0,
              ),
              child: FlashcardPreviewContent(),
            ),
          ),
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
        coursesBloc: context.read<CoursesBloc>(),
        groupsBloc: context.read<GroupsBloc>(),
      )..add(FlashcardPreviewEventInitialize(flashcardId: flashcardId)),
      child: child,
    );
  }
}
