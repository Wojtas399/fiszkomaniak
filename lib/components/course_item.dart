import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/courses_library/components/courses_library_course_item_info.dart';
import 'package:fiszkomaniak/features/courses_library/components/courses_library_course_popup_menu.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  final CourseItemParams params;

  const CourseItem({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: params.onPressed,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoursesLibraryCourseItemInfo(
                title: params.title,
                amountOfGroups: params.amountOfGroups,
              ),
              CoursesLibraryCoursePopupMenu(
                onActionSelected: params.onActionSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseItemParams extends Equatable {
  final String title;
  final int amountOfGroups;
  final VoidCallback onPressed;
  final Function(CoursePopupAction action) onActionSelected;

  const CourseItemParams({
    required this.title,
    required this.amountOfGroups,
    required this.onPressed,
    required this.onActionSelected,
  });

  @override
  List<Object> get props => [
        title,
        amountOfGroups,
      ];
}

CourseItemParams createCourseItemParams({
  String? title,
  int? amountOfGroups,
  VoidCallback? onPressed,
  Function(CoursePopupAction action)? onActionSelected,
}) {
  return CourseItemParams(
    title: title ?? '',
    amountOfGroups: amountOfGroups ?? 0,
    onPressed: onPressed ?? () {},
    onActionSelected: onActionSelected ?? (_) {},
  );
}
