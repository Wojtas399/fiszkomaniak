import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_dialogs.dart';
import 'package:fiszkomaniak/features/flashcard_preview/components/flashcard_preview_app_bar.dart';
import 'package:fiszkomaniak/features/flashcard_preview/components/flashcard_preview_content.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardPreview extends StatelessWidget {
  final FlashcardPreviewParams params;

  const FlashcardPreview({
    Key? key,
    required this.params,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _FlashcardPreviewBlocProvider(
      params: params,
      child: Scaffold(
        appBar: const FlashcardPreviewAppBar(),
        body: BouncingScroll(
          child: SafeArea(
            child: OnTapFocusLoseArea(
              child: Padding(
                padding: const EdgeInsets.only(
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
      ),
    );
  }
}

class _FlashcardPreviewBlocProvider extends StatelessWidget {
  final FlashcardPreviewParams params;
  final Widget child;

  const _FlashcardPreviewBlocProvider({
    Key? key,
    required this.params,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FlashcardPreviewBloc(
        coursesInterface: context.read<CoursesInterface>(),
        flashcardPreviewDialogs: FlashcardPreviewDialogs(),
      )..add(FlashcardPreviewEventInitialize(params: params)),
      child: child,
    );
  }
}
