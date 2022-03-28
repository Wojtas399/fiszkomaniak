import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/study/components/study_group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/courses/courses_state.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (_, CoursesState coursesState) {
        return BlocBuilder<GroupsBloc, GroupsState>(
          builder: (_, GroupsState groupsState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: groupsState.allGroups
                        .map(
                          (group) => StudyGroupItem(
                            courseName: coursesState.getCourseNameById(
                              group.courseId,
                            ),
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
