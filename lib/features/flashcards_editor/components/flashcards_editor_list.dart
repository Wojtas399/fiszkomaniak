import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/components/flashcards_editor_item.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardsEditorList extends StatelessWidget {
  const FlashcardsEditorList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardsEditorBloc, FlashcardsEditorState>(
      builder: (BuildContext context, FlashcardsEditorState state) {
        final String nameForQuestions = state.group?.nameForQuestions ?? '';
        final String nameForAnswers = state.group?.nameForAnswers ?? '';
        return Column(
          children: state.editorFlashcards
              .asMap()
              .entries
              .map(
                (entry) => _buildFlashcard(
                  entry.key,
                  entry.value,
                  nameForQuestions,
                  nameForAnswers,
                  state.isEditorFlashcardMarkedAsIncomplete(entry.value),
                  context,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildFlashcard(
    int index,
    EditorFlashcard editorFlashcard,
    String nameForQuestions,
    String nameForAnswers,
    bool isIncomplete,
    BuildContext context,
  ) {
    return FlashcardsEditorItem(
      key: ValueKey(editorFlashcard.key),
      questionInitialValue: editorFlashcard.question,
      answerInitialValue: editorFlashcard.answer,
      nameForQuestion: nameForQuestions,
      nameForAnswer: nameForAnswers,
      displayRedBorder: isIncomplete,
      onQuestionChanged: (String value) => _onQuestionChanged(
        index,
        value,
        context,
      ),
      onAnswerChanged: (String value) => _onAnswerChanged(
        index,
        value,
        context,
      ),
      onTapDeleteButton: () => _onDelete(index, context),
    );
  }

  void _onQuestionChanged(
    int flashcardIndex,
    String question,
    BuildContext context,
  ) {
    context.read<FlashcardsEditorBloc>().add(
          FlashcardsEditorEventValueChanged(
            flashcardIndex: flashcardIndex,
            question: question.trim(),
          ),
        );
  }

  void _onAnswerChanged(
    int flashcardIndex,
    String answer,
    BuildContext context,
  ) {
    context.read<FlashcardsEditorBloc>().add(
          FlashcardsEditorEventValueChanged(
            flashcardIndex: flashcardIndex,
            answer: answer.trim(),
          ),
        );
  }

  void _onDelete(int flashcardIndex, BuildContext context) {
    Utils.unfocusElements();
    context
        .read<FlashcardsEditorBloc>()
        .add(FlashcardsEditorEventRemoveFlashcard(
          flashcardIndex: flashcardIndex,
        ));
  }
}
