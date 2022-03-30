import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/select_item.dart';

class GroupCreatorCourseSelection extends StatelessWidget {
  const GroupCreatorCourseSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreatorBloc, GroupCreatorState>(
      builder: (BuildContext context, GroupCreatorState state) {
        return SelectItem(
          icon: MdiIcons.archiveOutline,
          label: 'Kurs',
          value: state.selectedCourse?.name ?? '',
          options: {
            for (final course in state.allCourses) course.id: course.name
          },
          onOptionSelected: (String key, String value) {
            final course = state.allCourses.firstWhere(
              (course) => course.id == key,
            );
            context
                .read<GroupCreatorBloc>()
                .add(GroupCreatorEventCourseChanged(course: course));
          },
        );
      },
    );
  }
}
