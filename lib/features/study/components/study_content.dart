import 'package:fiszkomaniak/features/study/bloc/study_bloc.dart';
import 'package:fiszkomaniak/features/study/components/study_groups_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/empty_content_info.dart';

class StudyContent extends StatelessWidget {
  const StudyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bool areGroups = context.select(
      (StudyBloc bloc) => bloc.state.areGroups,
    );
    if (areGroups) {
      return const BouncingScroll(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 16, right: 16, bottom: 32, left: 16),
            child: StudyGroupsList(),
          ),
        ),
      );
    }
    return const _NoGroupsInfo();
  }
}

class _NoGroupsInfo extends StatelessWidget {
  const _NoGroupsInfo();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: EmptyContentInfo(
          icon: MdiIcons.school,
          title: 'Brak utworzonych grup',
          subtitle:
              'Naciśnij fioletowy przycisk znajdujący się na dolnym pasku aby dodać nową grupę',
        ),
      ),
    );
  }
}
