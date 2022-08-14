import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/group_item.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/on_tap_focus_lose_area.dart';
import '../../../config/navigation.dart';
import '../../../domain/entities/group.dart';
import '../../../features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import '../../../utils/groups_utils.dart';

class CourseGroupsPreviewList extends StatelessWidget {
  const CourseGroupsPreviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnTapFocusLoseArea(
      child: BouncingScroll(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _GroupsList(),
          ),
        ),
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  const _GroupsList();

  @override
  Widget build(BuildContext context) {
    final String courseName = context.select(
      (CourseGroupsPreviewBloc bloc) => bloc.state.courseName,
    );
    final List<Group> groupsFromCourseMatchingToSearchValue = context.select(
      (CourseGroupsPreviewBloc bloc) =>
          bloc.state.groupsFromCourseMatchingToSearchValue,
    );
    return Column(
      children: GroupsUtils.setGroupInAlphabeticalOrderByName(
        groupsFromCourseMatchingToSearchValue,
      )
          .map(
            (Group group) => _GroupItem(
              group: group,
              courseName: courseName,
            ),
          )
          .toList(),
    );
  }
}

class _GroupItem extends StatelessWidget {
  final Group group;
  final String courseName;

  const _GroupItem({
    required this.group,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return GroupItem(
      groupName: group.name,
      courseName: courseName,
      amountOfRememberedFlashcards:
          GroupsUtils.getAmountOfRememberedFlashcards(group),
      amountOfAllFlashcards: group.flashcards.length,
      onPressed: () {
        Navigation.navigateToGroupPreview(group.id);
      },
    );
  }
}
