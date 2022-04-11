import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/components/flashcards_editor_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/group_model.dart';

class FlashcardsEditorFlashcardsList extends StatelessWidget {
  const FlashcardsEditorFlashcardsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardsEditorBloc, FlashcardsEditorState>(
      builder: (BuildContext context, FlashcardsEditorState state) {
        final Group? group = state.group;
        if (group == null) {
          return const Center(
            child: Text('No group selected'),
          );
        }
        return Column(
          children: state.flashcards.asMap().entries.map((entry) {
            final int index = entry.key;
            final FlashcardsEditorItemParams params = entry.value;
            return FlashcardsEditorItem(
              questionInitialValue: params.doc.question,
              answerInitialValue: params.doc.answer,
              nameForQuestion: group.nameForQuestions,
              nameForAnswer: group.nameForAnswers,
              onQuestionChanged: (String value) {
                context
                    .read<FlashcardsEditorBloc>()
                    .add(FlashcardsEditorEventQuestionChanged(
                      indexOfFlashcard: index,
                      question: value,
                    ));
              },
              onAnswerChanged: (String value) {
                context
                    .read<FlashcardsEditorBloc>()
                    .add(FlashcardsEditorEventAnswerChanged(
                      indexOfFlashcard: index,
                      answer: value,
                    ));
              },
            );
          }).toList(),
        );
      },
    );
  }
}
