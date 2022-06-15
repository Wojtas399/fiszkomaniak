import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/select_item/select_item.dart';

class GroupSelectionSelectCourseItem extends StatelessWidget {
  const GroupSelectionSelectCourseItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupSelectionBloc, GroupSelectionState>(
      builder: (BuildContext context, GroupSelectionState state) {
        return SelectItem(
          icon: MdiIcons.archiveOutline,
          value: state.selectedCourse?.name,
          label: 'Kurs',
          optionsListTitle: 'Wybierz kurs',
          options: state.coursesToSelect,
          onOptionSelected: (String key, String value) {
            context
                .read<GroupSelectionBloc>()
                .add(GroupSelectionEventCourseSelected(courseId: key));
          },
        );
      },
    );
  }
}
