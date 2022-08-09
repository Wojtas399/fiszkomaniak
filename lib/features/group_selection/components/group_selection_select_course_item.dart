import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/select_item/select_item.dart';
import '../../../domain/entities/course.dart';
import '../bloc/group_selection_bloc.dart';

class GroupSelectionSelectCourseItem extends StatelessWidget {
  const GroupSelectionSelectCourseItem({super.key});

  @override
  Widget build(BuildContext context) {
    final String? selectedCourseName = context.select(
      (GroupSelectionBloc bloc) => bloc.state.selectedCourse?.name,
    );
    final List<Course> allCourses = context.select(
      (GroupSelectionBloc bloc) => bloc.state.allCourses,
    );
    return SelectItem(
      icon: MdiIcons.archiveOutline,
      value: selectedCourseName,
      label: 'Kurs',
      optionsListTitle: 'Wybierz kurs',
      options: _convertCoursesToMap(allCourses),
      onOptionSelected: (String courseId, String courseName) =>
          _onCourseSelected(courseId, context),
    );
  }

  Map<String, String> _convertCoursesToMap(List<Course> courses) {
    return {for (final Course course in courses) course.id: course.name};
  }

  void _onCourseSelected(String courseId, BuildContext context) {
    context
        .read<GroupSelectionBloc>()
        .add(GroupSelectionEventCourseSelected(courseId: courseId));
  }
}
