import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/features/study/bloc/study_bloc.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../interfaces/groups_interface.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StudyBlocProvider(
      child: BlocBuilder<StudyBloc, StudyState>(
        builder: (_, StudyState state) {
          if (state.groupsItems.isEmpty) {
            return const _NoGroupsInfo();
          }
          return BouncingScroll(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  right: 16,
                  bottom: 32,
                  left: 16,
                ),
                child: Column(
                  children: _buildGroups(context, state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildGroups(BuildContext context, StudyState state) {
    return state.groupsItems
        .map(
          (item) => GroupItem(
            courseName: item.courseName,
            groupName: item.groupName,
            amountOfRememberedFlashcards: item.amountOfRememberedFlashcards,
            amountOfAllFlashcards: item.amountOfAllFlashcards,
            onTap: () {
              context.read<Navigation>().navigateToGroupPreview(item.groupId);
            },
          ),
        )
        .toList();
  }
}

class _StudyBlocProvider extends StatelessWidget {
  final Widget child;

  const _StudyBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => StudyBloc(
        coursesInterface: context.read<CoursesInterface>(),
        groupsInterface: context.read<GroupsInterface>(),
        flashcardsInterface: context.read<FlashcardsInterface>(),
      )..add(StudyEventInitialize()),
      child: child,
    );
  }
}

class _NoGroupsInfo extends StatelessWidget {
  const _NoGroupsInfo();

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
