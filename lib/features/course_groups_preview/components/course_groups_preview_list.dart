import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/on_tap_focus_lose_area.dart';

class CourseGroupsPreviewList extends StatelessWidget {
  const CourseGroupsPreviewList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseGroupsPreviewBloc, CourseGroupsPreviewState>(
      builder: (
        BuildContext context,
        CourseGroupsPreviewState courseGroupsPreviewState,
      ) {
        return BlocBuilder<FlashcardsBloc, FlashcardsState>(
          builder: (BuildContext context, FlashcardsState flashcardsState) {
            return OnTapFocusLoseArea(
              child: BouncingScroll(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: _buildGroups(
                        context,
                        courseGroupsPreviewState,
                        flashcardsState,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildGroups(
    BuildContext context,
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
              context.read<Navigation>().navigateToGroupPreview(group.id);
            },
          ),
        )
        .toList();
  }
}
