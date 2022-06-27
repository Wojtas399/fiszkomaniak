import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/section.dart';

class GroupPreviewInformation extends StatelessWidget {
  const GroupPreviewInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Informacje',
      displayDividerAtTheBottom: true,
      child: Column(
        children: const [
          _CourseName(),
          _NameForQuestions(),
          _NameForAnswers(),
        ],
      ),
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName();

  @override
  Widget build(BuildContext context) {
    final String? courseName = context.select(
      (GroupPreviewBloc bloc) => bloc.state.course?.name,
    );
    return ItemWithIcon(
      icon: MdiIcons.archiveOutline,
      label: 'Kurs',
      text: courseName ?? '',
    );
  }
}

class _NameForQuestions extends StatelessWidget {
  const _NameForQuestions();

  @override
  Widget build(BuildContext context) {
    final String? nameForQuestions = context.select(
      (GroupPreviewBloc bloc) => bloc.state.group?.nameForQuestions,
    );
    return ItemWithIcon(
      icon: MdiIcons.fileOutline,
      label: 'Pytania',
      text: nameForQuestions ?? '',
    );
  }
}

class _NameForAnswers extends StatelessWidget {
  const _NameForAnswers();

  @override
  Widget build(BuildContext context) {
    final String? nameForAnswers = context.select(
      (GroupPreviewBloc bloc) => bloc.state.group?.nameForAnswers,
    );
    return ItemWithIcon(
      icon: MdiIcons.fileReplaceOutline,
      label: 'Odpowiedzi',
      text: nameForAnswers ?? '',
    );
  }
}
