import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseGroupsPreviewGroupsList extends StatelessWidget {
  const CourseGroupsPreviewGroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseGroupsPreviewBloc, CourseGroupsPreviewState>(
      builder: (BuildContext context, CourseGroupsPreviewState state) {
        return Column(
          children: state.matchedGroups
              .map(
                (group) => GroupItem(
                  groupName: group.name,
                  amountOfLearnedFlashcards: 250,
                  amountOfAllFlashcards: 500,
                  onTap: () {
                    Navigation.navigateToGroupPreview(group.id);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
