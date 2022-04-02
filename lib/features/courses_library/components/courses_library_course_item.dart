import 'package:fiszkomaniak/features/courses_library/components/courses_library_course_item_info.dart';
import 'package:fiszkomaniak/features/courses_library/components/courses_library_course_popup_menu.dart';
import 'package:flutter/material.dart';

class CoursesLibraryCourseItem extends StatelessWidget {
  final String title;
  final int amountOfGroups;
  final VoidCallback onTap;
  final Function(CoursePopupAction action) onActionSelected;

  const CoursesLibraryCourseItem({
    Key? key,
    required this.title,
    required this.amountOfGroups,
    required this.onTap,
    required this.onActionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoursesLibraryCourseItemInfo(
                title: title,
                amountOfGroups: amountOfGroups,
              ),
              CoursesLibraryCoursePopupMenu(onActionSelected: onActionSelected),
            ],
          ),
        ),
      ),
    );
  }
}
