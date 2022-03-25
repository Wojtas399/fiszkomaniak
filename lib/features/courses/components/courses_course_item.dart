import 'package:fiszkomaniak/features/courses/components/courses_course_item_info.dart';
import 'package:fiszkomaniak/features/courses/components/courses_course_popup_menu.dart';
import 'package:flutter/material.dart';

class CoursesCourseItem extends StatelessWidget {
  final String title;
  final int amountOfGroups;
  final Function(CoursePopupAction action) onActionSelected;

  const CoursesCourseItem({
    Key? key,
    required this.title,
    required this.amountOfGroups,
    required this.onActionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoursesCourseItemInfo(
                title: title,
                amountOfGroups: amountOfGroups,
              ),
              CoursesCoursePopupMenu(onActionSelected: onActionSelected),
            ],
          ),
        ),
      ),
    );
  }
}
