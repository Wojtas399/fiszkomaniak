import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/list_view_fade_animated_item.dart';
import '../../../providers/dialogs_provider.dart';
import '../../../utils/utils.dart';
import '../bloc/flashcards_editor_bloc.dart';
import '../components/flashcards_editor_item.dart';

class FlashcardsEditorList extends StatelessWidget {
  const FlashcardsEditorList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardsEditorBloc, FlashcardsEditorState>(
      builder: (BuildContext context, FlashcardsEditorState state) {
        final String nameForQuestions = state.group?.nameForQuestions ?? '';
        final String nameForAnswers = state.group?.nameForAnswers ?? '';

        return ListView.builder(
          cacheExtent: 0,
          padding: const EdgeInsets.all(24),
          itemCount: state.editorFlashcards.length,
          itemBuilder: (_, int index) {
            final EditorFlashcard editorFlashcard =
                state.editorFlashcards[index];

            return ListViewFadeAnimatedItem(
              child: FlashcardsEditorItem(
                key: ValueKey(editorFlashcard.key),
                questionInitialValue: editorFlashcard.question,
                answerInitialValue: editorFlashcard.answer,
                nameForQuestion: nameForQuestions,
                nameForAnswer: nameForAnswers,
                displayRedBorder: state.isEditorFlashcardMarkedAsIncomplete(
                  editorFlashcard,
                ),
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
              ),
            );
          },
        );
      },
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

  Future<void> _onDelete(int flashcardIndex, BuildContext context) async {
    Utils.unfocusElements();
    await _deleteFlashcard(flashcardIndex, context);
  }

  Future<void> _deleteFlashcard(
    int flashcardIndex,
    BuildContext context,
  ) async {
    final FlashcardsEditorBloc bloc = context.read<FlashcardsEditorBloc>();
    final bool confirmation = await _askForFlashcardDeletionConfirmation();
    if (confirmation) {
      bloc.add(
        FlashcardsEditorEventDeleteFlashcard(
          flashcardIndex: flashcardIndex,
        ),
      );
    }
  }

  Future<bool> _askForFlashcardDeletionConfirmation() async {
    return await DialogsProvider.askForConfirmation(
      title: 'Usuwanie',
      text:
          'Operacja ta jest nieodwracalna i spowoduje trwałe usunięcie fiszki. Czy na pewno chcesz usunąć fiszkę?',
      confirmButtonText: 'Usuń',
    );
  }
}
