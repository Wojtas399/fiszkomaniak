import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/select_item/select_item.dart';
import '../../../domain/entities/course.dart';
import '../bloc/group_creator_bloc.dart';

class GroupCreatorCourseSelection extends StatelessWidget {
  const GroupCreatorCourseSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreatorBloc, GroupCreatorState>(
      builder: (BuildContext context, GroupCreatorState state) {
        return SelectItem(
          icon: MdiIcons.archiveOutline,
          value: state.selectedCourse?.name,
          label: 'Kurs',
          optionsListTitle: 'Wybierz kurs',
          options: {
            for (final course in state.allCourses) course.id: course.name
          },
          onOptionSelected: (String key, _) => _onOptionSelected(
            context,
            key,
            state.allCourses,
          ),
        );
      },
    );
  }

  void _onOptionSelected(
    BuildContext context,
    String key,
    List<Course> allCourses,
  ) {
    final course = allCourses.firstWhere(
      (course) => course.id == key,
    );
    context
        .read<GroupCreatorBloc>()
        .add(GroupCreatorEventCourseChanged(course: course));
  }
}
