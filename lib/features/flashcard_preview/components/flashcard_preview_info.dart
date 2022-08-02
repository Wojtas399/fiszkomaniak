import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/features/flashcard_preview/components/flashcard_preview_question_answer.dart';
import 'package:fiszkomaniak/ui_extensions/flashcard_status_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FlashcardPreviewInfo extends StatelessWidget {
  const FlashcardPreviewInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _FlashcardStatus(),
        _CourseName(),
        _GroupName(),
        FlashcardPreviewQuestionAnswer(),
      ],
    );
  }
}

class _FlashcardStatus extends StatelessWidget {
  const _FlashcardStatus();

  @override
  Widget build(BuildContext context) {
    final FlashcardStatus? flashcardStatus = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.flashcard?.status,
    );
    return ItemWithIcon(
      icon: MdiIcons.checkCircleOutline,
      label: 'Status',
      text: flashcardStatus?.toUIFormat() ?? '--',
      iconColor: flashcardStatus?.toColor(),
      textColor: flashcardStatus?.toColor(),
      paddingLeft: 8,
      paddingRight: 8,
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName();

  @override
  Widget build(BuildContext context) {
    final String courseName = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.courseName,
    );
    return ItemWithIcon(
      icon: MdiIcons.archiveOutline,
      label: 'Kurs',
      text: courseName,
      paddingLeft: 8,
      paddingRight: 8,
    );
  }
}

class _GroupName extends StatelessWidget {
  const _GroupName();

  @override
  Widget build(BuildContext context) {
    final String? groupName = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.group?.name,
    );
    return ItemWithIcon(
      icon: MdiIcons.folderOutline,
      label: 'Grupa',
      text: groupName ?? '--',
      paddingLeft: 8,
      paddingRight: 8,
    );
  }
}
