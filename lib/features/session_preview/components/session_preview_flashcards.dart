import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/components/session_flashcards_type_picker.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
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
        final Session? session = state.session;
        if (session == null) {
          return const SizedBox();
        }
        return Stack(
          children: [
            Column(
              children: [
                SessionFlashcardsTypePicker(
                  selectedType: session.flashcardsType,
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
            Positioned(
              right: 0.0,
              bottom: 42.0,
              child: CustomIconButton(
                icon: MdiIcons.swapVertical,
                onPressed: () {},
              ),
            ),
          ],
        );
      },
    );
  }
}
