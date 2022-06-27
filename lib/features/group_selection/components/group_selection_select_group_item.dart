import 'package:fiszkomaniak/components/select_item/select_item.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupSelectionSelectGroupItem extends StatelessWidget {
  const GroupSelectionSelectGroupItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupSelectionBloc, GroupSelectionState>(
      builder: (BuildContext context, GroupSelectionState state) {
        return SelectItem(
          icon: MdiIcons.folderOutline,
          value: state.selectedGroup?.name,
          label: 'Grupa',
          optionsListTitle: 'Wybierz grupę',
          options: state.groupsFromCourseToSelect,
          noOptionsMessage: _getNoOptionsMessage(state.selectedCourse != null),
          onOptionSelected: (String key, String value) {
            context
                .read<GroupSelectionBloc>()
                .add(GroupSelectionEventGroupSelected(groupId: key));
          },
        );
      },
    );
  }

  String _getNoOptionsMessage(bool hasCourseBeenSelected) {
    if (hasCourseBeenSelected) {
      return 'W tym kursie nie ma żadnych utworzonych grup';
    }
    return 'Wybierz kurs aby wyświetlić listę grup';
  }
}
