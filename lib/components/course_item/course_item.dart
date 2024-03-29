import 'package:flutter/material.dart';
import 'course_item_info.dart';
import 'course_item_popup_menu.dart';

class CourseItem extends StatelessWidget {
  final String courseName;
  final int amountOfGroups;
  final VoidCallback onPressed;
  final Function(CoursePopupAction action) onActionSelected;

  const CourseItem({
    super.key,
    required this.courseName,
    required this.amountOfGroups,
    required this.onPressed,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CourseItemInfo(
                title: courseName,
                amountOfGroups: amountOfGroups,
              ),
              CourseItemPopupMenu(
                onActionSelected: onActionSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
