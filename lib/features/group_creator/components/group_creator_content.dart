import 'package:flutter/material.dart';
import '../../../components/on_tap_focus_lose_area.dart';
import 'group_creator_app_bar.dart';
import 'group_creator_course_selection.dart';
import 'group_creator_group_info.dart';
import 'group_creator_submit_button.dart';

class GroupCreatorContent extends StatelessWidget {
  const GroupCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupCreatorAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: OnTapFocusLoseArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const GroupCreatorCourseSelection(),
                    const SizedBox(height: 24),
                    GroupCreatorGroupInfo(),
                  ],
                ),
                const GroupCreatorSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}