import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/flashcards_stack_bloc.dart';

class FlashcardsStackBlocProvider extends StatelessWidget {
  final Widget child;

  const FlashcardsStackBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashcardsStackBloc(),
      child: child,
    );
  }
}
