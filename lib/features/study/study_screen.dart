import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../components/empty_content_info.dart';
import '../../components/group_item.dart';
import '../../components/list_view_fade_animated_item.dart';
import '../../config/navigation.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/group.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/groups/get_all_groups_use_case.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../utils/groups_utils.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StudyContent();
  }
}

class _StudyContent extends StatelessWidget {
  const _StudyContent();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetAllGroupsUseCase(
        groupsInterface: context.read<GroupsInterface>(),
      ).execute(),
      builder: (BuildContext context, AsyncSnapshot<List<Group>> snapshot) {
        final List<Group>? allGroups = snapshot.data;
        if (allGroups != null && allGroups.isNotEmpty) {
          return _GroupsList(allGroups: allGroups);
        }
        return const _NoGroupsInfo();
      },
    );
  }
}

class _GroupsList extends StatelessWidget {
  final List<Group> allGroups;

  const _GroupsList({required this.allGroups});

  @override
  Widget build(BuildContext context) {
    final List<Group> allGroups = GroupsUtils.setGroupInAlphabeticalOrderByName(
      this.allGroups,
    );

    return ListView.builder(
      cacheExtent: 0,
      padding: const EdgeInsets.only(
        top: 16,
        right: 16,
        bottom: 100,
        left: 16,
      ),
      itemCount: allGroups.length,
      itemBuilder: (_, int index) {
        return ListViewFadeAnimatedItem(
          child: _GroupItem(
            group: allGroups[index],
          ),
        );
      },
    );
  }
}

class _GroupItem extends StatelessWidget {
  final Group group;

  const _GroupItem({required this.group});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _getCourseName(context),
      builder: (_, AsyncSnapshot<String> snapshot) {
        return GroupItem(
          key: ObjectKey(group),
          groupName: group.name,
          courseName: snapshot.data ?? '',
          amountOfRememberedFlashcards:
              GroupsUtils.getAmountOfRememberedFlashcards(group),
          amountOfAllFlashcards: group.flashcards.length,
          onPressed: () {
            Navigation.navigateToGroupPreview(group.id);
          },
        );
      },
    );
  }

  Stream<String> _getCourseName(BuildContext context) {
    return GetCourseUseCase(coursesInterface: context.read<CoursesInterface>())
        .execute(courseId: group.courseId)
        .map((Course course) => course.name);
  }
}

class _NoGroupsInfo extends StatelessWidget {
  const _NoGroupsInfo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: EmptyContentInfo(
        icon: MdiIcons.school,
        title: 'Brak utworzonych grup',
        subtitle:
            'Naciśnij fioletowy przycisk znajdujący się na dolnym pasku aby dodać nową grupę',
      ),
    );
  }
}
