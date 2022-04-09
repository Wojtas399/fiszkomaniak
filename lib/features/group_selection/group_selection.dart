import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/button.dart';
import 'package:fiszkomaniak/features/group_selection/components/group_selection_flashcards_info.dart';
import 'package:fiszkomaniak/features/group_selection/components/group_selection_select_course_item.dart';
import 'package:fiszkomaniak/features/group_selection/components/group_selection_select_group_item.dart';
import 'package:flutter/material.dart';

class GroupSelection extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  GroupSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithCloseButton(label: 'Wybór grupy'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 24.0,
            left: 24.0,
            right: 24.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: const [
                  GroupSelectionSelectCourseItem(),
                  GroupSelectionSelectGroupItem(),
                  GroupSelectionFlashcardsInfo(),
                ],
              ),
              Button(
                label: 'Rozpocznij dodawanie',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
