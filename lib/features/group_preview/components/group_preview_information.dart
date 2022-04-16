import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/section.dart';

class GroupPreviewInformation extends StatelessWidget {
  const GroupPreviewInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupPreviewBloc, GroupPreviewState>(
      builder: (_, GroupPreviewState state) {
        return Section(
          title: 'Informacje',
          displayDividerAtTheBottom: true,
          child: Column(
            children: [
              ItemWithIcon(
                icon: MdiIcons.archiveOutline,
                label: 'Kurs',
                text: state.courseName,
              ),
              ItemWithIcon(
                icon: MdiIcons.fileOutline,
                label: 'Pytania',
                text: state.group?.nameForQuestions ?? '',
              ),
              ItemWithIcon(
                icon: MdiIcons.fileReplaceOutline,
                label: 'Odpowiedzi',
                text: state.group?.nameForAnswers ?? '',
              ),
            ],
          ),
        );
      },
    );
  }
}
