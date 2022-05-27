import 'package:fiszkomaniak/ui_extensions/flashcards_type_converters.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LearningProcessHeader extends StatelessWidget {
  const LearningProcessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _CourseName(),
          SizedBox(height: 8.0),
          _GroupName(),
          SizedBox(height: 4.0),
          _FlashcardsType(),
        ],
      ),
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName();

  @override
  Widget build(BuildContext context) {
    final String courseName = context.select(
      (LearningProcessBloc bloc) => bloc.state.courseName,
    );
    return Text(courseName, style: Theme.of(context).textTheme.subtitle1);
  }
}

class _GroupName extends StatelessWidget {
  const _GroupName();

  @override
  Widget build(BuildContext context) {
    final String? groupName = context.select(
      (LearningProcessBloc bloc) => bloc.state.group?.name,
    );
    return Text(
      groupName ?? '',
      style: Theme.of(context).textTheme.headline6,
      maxLines: 2,
    );
  }
}

class _FlashcardsType extends StatelessWidget {
  const _FlashcardsType();

  @override
  Widget build(BuildContext context) {
    final FlashcardsType? type = context.select(
      (LearningProcessBloc bloc) => bloc.state.flashcardsType,
    );
    return Text(
      convertFlashcardsTypeToViewFormat(type),
      style: TextStyle(color: Colors.black.withOpacity(0.60)),
    );
  }
}
