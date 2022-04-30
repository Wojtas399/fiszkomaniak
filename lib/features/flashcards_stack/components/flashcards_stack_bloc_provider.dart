import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/flashcards_stack_models.dart';

class FlashcardsStackBlocProvider extends StatelessWidget {
  final List<FlashcardInfo> flashcards;
  final Widget child;

  const FlashcardsStackBlocProvider({
    Key? key,
    required this.flashcards,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashcardsStackBloc()
        ..add(FlashcardsStackEventInitialize(flashcards: flashcards)),
      child: child,
    );
  }
}
