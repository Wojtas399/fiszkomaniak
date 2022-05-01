import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_app_bar.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/learning_process_event.dart';
import 'bloc/learning_process_state.dart';

class LearningProcess extends StatelessWidget {
  final LearningProcessData data;

  const LearningProcess({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _LearningProcessBlocProvider(
      data: data,
      child: const Scaffold(
        appBar: LearningProcessAppBar(),
        body: LearningProcessContent(),
      ),
    );
  }
}

class _LearningProcessBlocProvider extends StatelessWidget {
  final LearningProcessData data;
  final Widget child;

  const _LearningProcessBlocProvider({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LearningProcessBloc(
        flashcardsBloc: context.read<FlashcardsBloc>(),
      )..add(LearningProcessEventInitialize(data: data)),
      child: child,
    );
  }
}
