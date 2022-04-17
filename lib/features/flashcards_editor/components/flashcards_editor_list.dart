import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/components/flashcards_editor_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/group_model.dart';

class FlashcardsEditorList extends StatelessWidget {
  const FlashcardsEditorList({Key? key}) : super(key: key);

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
        return ListView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 24.0,
            top: 24.0,
            right: 24.0,
            bottom: 48.0,
          ),
          children: _buildFlashcards(context, state, group),
        );
      },
    );
  }

  List<Widget> _buildFlashcards(
    BuildContext context,
    FlashcardsEditorState state,
    Group group,
  ) {
    return state.flashcards
        .asMap()
        .entries
        .map(
          (entry) {
            final int index = entry.key;
            final EditorFlashcard params = entry.value;
            return FlashcardsEditorItem(
              key: ValueKey(params.key),
              questionInitialValue: params.doc.question,
              answerInitialValue: params.doc.answer,
              nameForQuestion: group.nameForQuestions,
              nameForAnswer: group.nameForAnswers,
              displayRedBorder: !params.isCorrect,
              onQuestionChanged: (String value) {
                context
                    .read<FlashcardsEditorBloc>()
                    .add(FlashcardsEditorEventValueChanged(
                      indexOfFlashcard: index,
                      question: value.trim(),
                    ));
              },
              onAnswerChanged: (String value) {
                context
                    .read<FlashcardsEditorBloc>()
                    .add(FlashcardsEditorEventValueChanged(
                      indexOfFlashcard: index,
                      answer: value.trim(),
                    ));
              },
              onTapDeleteButton: () {
                context
                    .read<FlashcardsEditorBloc>()
                    .add(FlashcardsEditorEventRemoveFlashcard(
                      indexOfFlashcard: index,
                    ));
              },
            );
          },
        )
        .toList()
        .reversed
        .toList();
  }
}
