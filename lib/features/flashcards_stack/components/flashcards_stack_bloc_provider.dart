import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardsStackBlocProvider extends StatelessWidget {
  final Widget child;

  const FlashcardsStackBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashcardsStackBloc(),
      child: child,
    );
  }
}
