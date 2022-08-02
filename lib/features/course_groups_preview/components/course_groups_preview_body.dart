import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/components/course_groups_preview_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CourseGroupsPreviewBody extends StatelessWidget {
  const CourseGroupsPreviewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bool areGroupsInCourse = context.select(
      (CourseGroupsPreviewBloc bloc) => bloc.state.areGroupsInCourse,
    );
    if (areGroupsInCourse) {
      return const CourseGroupsPreviewList();
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
        padding: EdgeInsets.all(24.0),
        child: EmptyContentInfo(
          icon: MdiIcons.folder,
          title: 'Brak grup w kursie',
          subtitle: 'Utwórz grupy dla tego kursu aby móc je przeglądać',
        ),
      ),
    );
  }
}
