import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/components/flashcards_type_picker.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SessionPreviewFlashcards extends StatelessWidget {
  const SessionPreviewFlashcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionPreviewBloc, SessionPreviewState>(
      builder: (BuildContext context, SessionPreviewState state) {
        final FlashcardsType? flashcardsType = state.flashcardsType;
        if (flashcardsType == null) {
          return const SizedBox();
        }
        return Stack(
          children: [
            Column(
              children: [
                FlashcardsTypePicker(
                  selectedType: flashcardsType,
                  onTypeChanged: state.mode is SessionPreviewModeQuick
                      ? (FlashcardsType type) => _onFlashcardsTypeChanged(
                            context,
                            type,
                          )
                      : null,
                ),
                ItemWithIcon(
                  icon: MdiIcons.fileOutline,
                  label: 'Pytania',
                  text: state.nameForQuestions ?? '--',
                  paddingLeft: 8.0,
                  paddingRight: 8.0,
                ),
                ItemWithIcon(
                  icon: MdiIcons.fileReplaceOutline,
                  label: 'Odpowiedzi',
                  text: state.nameForAnswers ?? '--',
                  paddingLeft: 8.0,
                  paddingRight: 8.0,
                ),
              ],
            ),
            state.mode is SessionPreviewModeQuick
                ? Positioned(
                    right: 0.0,
                    bottom: 42.0,
                    child: CustomIconButton(
                      icon: MdiIcons.swapVertical,
                      onPressed: () => _swapQuestionsAndAnswers(context),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }

  void _onFlashcardsTypeChanged(BuildContext context, FlashcardsType type) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventFlashcardsTypeChanged(flashcardsType: type));
  }

  void _swapQuestionsAndAnswers(BuildContext context) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventSwapQuestionsAndAnswers());
  }
}
