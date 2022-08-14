import 'package:flutter/material.dart';
import '../../../components/app_bars/app_bar_with_close_button.dart';
import 'group_selection_button.dart';
import 'group_selection_flashcards_info.dart';
import 'group_selection_select_course_item.dart';
import 'group_selection_select_group_item.dart';

class GroupSelectionContent extends StatelessWidget {
  const GroupSelectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: 'Wybór grupy'),
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
              const GroupSelectionButton(),
            ],
          ),
        ),
      ),
    );
  }
}
