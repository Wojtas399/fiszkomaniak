import 'package:fiszkomaniak/components/app_bar_with_search_text_field.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseGroupsPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CourseGroupsPreviewAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseGroupsPreviewBloc, CourseGroupsPreviewState>(
      builder: (BuildContext context, CourseGroupsPreviewState state) {
        return AppBarWithSearchTextField(
          label: state.courseName,
          onChanged: (String value) {
            context.read<CourseGroupsPreviewBloc>().add(
                  CourseGroupsPreviewEventSearchValueChanged(
                    searchValue: value,
                  ),
                );
          },
        );
      },
    );
  }
}
