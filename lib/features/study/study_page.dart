import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/courses/courses_state.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (_, CoursesState coursesState) {
        return BlocBuilder<GroupsBloc, GroupsState>(
          builder: (_, GroupsState groupsState) {
            if (groupsState.allGroups.isEmpty) {
              return const _NoGroupsInfo();
            }
            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    right: 16,
                    bottom: 32,
                    left: 16,
                  ),
                  child: Column(
                    children: groupsState.allGroups
                        .map(
                          (group) => GroupItem(
                            courseName: coursesState.getCourseNameById(
                                  group.courseId,
                                ) ??
                                '',
                            groupName: group.name,
                            amountOfLearnedFlashcards: 250,
                            amountOfAllFlashcards: 500,
                            onTap: () {
                              Navigation.navigateToGroupPreview(group.id);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _NoGroupsInfo extends StatelessWidget {
  const _NoGroupsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: EmptyContentInfo(
          icon: MdiIcons.school,
          title: 'Brak utworzonych grup',
          subtitle:
              'Naciśnij fioletowy przycisk znajdujący się na dolnym pasku aby dodać nową grupę',
        ),
      ),
    );
  }
}
