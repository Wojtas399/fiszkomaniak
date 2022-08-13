import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/select_item.dart';
import '../../../domain/entities/course.dart';
import '../bloc/group_creator_bloc.dart';

class GroupCreatorCourseSelection extends StatelessWidget {
  const GroupCreatorCourseSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final Course? selectedCourse = context.select(
      (GroupCreatorBloc bloc) => bloc.state.selectedCourse,
    );
    final List<Course> allCourses = context.select(
      (GroupCreatorBloc bloc) => bloc.state.allCourses,
    );
    return SelectItem(
      icon: MdiIcons.archiveOutline,
      value: selectedCourse?.name,
      label: 'Kurs',
      optionsListTitle: 'Wybierz kurs',
      options: {for (final course in allCourses) course.id: course.name},
      onOptionSelected: (String selectedCourseId, _) => _onOptionSelected(
        context,
        selectedCourseId,
        allCourses,
      ),
    );
  }

  void _onOptionSelected(
    BuildContext context,
    String selectedCourseId,
    List<Course> allCourses,
  ) {
    final course = allCourses.firstWhere(
      (course) => course.id == selectedCourseId,
    );
    context
        .read<GroupCreatorBloc>()
        .add(GroupCreatorEventCourseChanged(course: course));
  }
}
