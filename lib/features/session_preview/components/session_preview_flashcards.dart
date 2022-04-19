import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/converters/flashcards_type_converter.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SessionPreviewFlashcards extends StatelessWidget {
  const SessionPreviewFlashcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionPreviewBloc, SessionPreviewState>(
      builder: (BuildContext context, SessionPreviewState state) {
        return Section(
          title: 'Fiszki',
          displayDividerAtTheBottom: true,
          child: Column(
            children: [
              ItemWithIcon(
                icon: MdiIcons.archiveOutline,
                label: 'Kurs',
                text: state.courseName ?? '--',
                paddingLeft: 8.0,
                paddingRight: 8.0,
              ),
              ItemWithIcon(
                icon: MdiIcons.folderOutline,
                label: 'Grupa',
                text: state.group?.name ?? '--',
                paddingLeft: 8.0,
                paddingRight: 8.0,
              ),
              ItemWithIcon(
                icon: MdiIcons.cardsOutline,
                label: 'Rodzaj',
                text: convertFlashcardsTypeToViewFormat(
                  state.session?.flashcardsType,
                ),
                paddingLeft: 8.0,
                paddingRight: 8.0,
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
        );
      },
    );
  }
}
