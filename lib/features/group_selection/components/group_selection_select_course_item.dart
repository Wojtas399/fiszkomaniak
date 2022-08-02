import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/select_item/select_item.dart';

class GroupSelectionSelectCourseItem extends StatelessWidget {
  const GroupSelectionSelectCourseItem({super.key});

  @override
  Widget build(BuildContext context) {
    final String? selectedCourseName = context.select(
      (GroupSelectionBloc bloc) => bloc.state.selectedCourse?.name,
    );
    final Map<String, String> coursesToSelect = context.select(
      (GroupSelectionBloc bloc) => bloc.state.coursesToSelect,
    );
    return SelectItem(
      icon: MdiIcons.archiveOutline,
      value: selectedCourseName,
      label: 'Kurs',
      optionsListTitle: 'Wybierz kurs',
      options: coursesToSelect,
      onOptionSelected: (String key, String value) {
        context
            .read<GroupSelectionBloc>()
            .add(GroupSelectionEventCourseSelected(courseId: key));
      },
    );
  }
}
