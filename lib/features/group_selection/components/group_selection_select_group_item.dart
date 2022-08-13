import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/select_item.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/group.dart';
import '../bloc/group_selection_bloc.dart';

class GroupSelectionSelectGroupItem extends StatelessWidget {
  const GroupSelectionSelectGroupItem({super.key});

  @override
  Widget build(BuildContext context) {
    final Course? selectedCourse = context.select(
      (GroupSelectionBloc bloc) => bloc.state.selectedCourse,
    );
    final Group? selectedGroup = context.select(
      (GroupSelectionBloc bloc) => bloc.state.selectedGroup,
    );
    final List<Group> groupsFromCourse = context.select(
      (GroupSelectionBloc bloc) => bloc.state.groupsFromCourse,
    );
    return SelectItem(
      icon: MdiIcons.folderOutline,
      value: selectedGroup?.name,
      label: 'Grupa',
      optionsListTitle: 'Wybierz grupę',
      options: _convertGroupsToMap(groupsFromCourse),
      noOptionsMessage: _getNoOptionsMessage(selectedCourse != null),
      onOptionSelected: (String groupId, String groupName) =>
          _onGroupSelected(groupId, context),
    );
  }

  Map<String, String> _convertGroupsToMap(List<Group> groups) {
    return {for (final Group group in groups) group.id: group.name};
  }

  String _getNoOptionsMessage(bool hasCourseBeenSelected) {
    if (hasCourseBeenSelected) {
      return 'W tym kursie nie ma żadnych utworzonych grup';
    }
    return 'Wybierz kurs aby wyświetlić listę grup';
  }

  void _onGroupSelected(String groupId, BuildContext context) {
    context
        .read<GroupSelectionBloc>()
        .add(GroupSelectionEventGroupSelected(groupId: groupId));
  }
}
