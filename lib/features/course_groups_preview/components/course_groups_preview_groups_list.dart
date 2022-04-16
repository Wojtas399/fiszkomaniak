import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseGroupsPreviewGroupsList extends StatelessWidget {
  const CourseGroupsPreviewGroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseGroupsPreviewBloc, CourseGroupsPreviewState>(
      builder: (
        BuildContext context,
        CourseGroupsPreviewState courseGroupsPreviewState,
      ) {
        return BlocBuilder<FlashcardsBloc, FlashcardsState>(
          builder: (BuildContext context, FlashcardsState flashcardsState) {
            return Column(
              children: _buildGroups(
                courseGroupsPreviewState,
                flashcardsState,
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildGroups(
    CourseGroupsPreviewState courseGroupsPreviewState,
    FlashcardsState flashcardsState,
  ) {
    return courseGroupsPreviewState.matchingGroups
        .map(
          (group) => GroupItem(
            groupName: group.name,
            amountOfRememberedFlashcards: flashcardsState
                .getAmountOfRememberedFlashcardsFromGroup(group.id),
            amountOfAllFlashcards:
                flashcardsState.getAmountOfAllFlashcardsFromGroup(group.id),
            onTap: () {
              Navigation.navigateToGroupPreview(group.id);
            },
          ),
        )
        .toList();
  }
}
