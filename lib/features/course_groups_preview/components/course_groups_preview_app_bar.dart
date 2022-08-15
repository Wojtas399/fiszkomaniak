import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_bars/app_bar_with_search_text_field.dart';
import '../../../features/course_groups_preview/bloc/course_groups_preview_bloc.dart';

class CourseGroupsPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CourseGroupsPreviewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final String courseName = context.select(
      (CourseGroupsPreviewBloc bloc) => bloc.state.courseName,
    );
    return AppBarWithSearchTextField(
      label: courseName,
      onChanged: (String value) => _onSearchValueChanged(context, value),
    );
  }

  void _onSearchValueChanged(BuildContext context, String searchValue) {
    context.read<CourseGroupsPreviewBloc>().add(
          CourseGroupsPreviewEventSearchValueChanged(
            searchValue: searchValue,
          ),
        );
  }
}
