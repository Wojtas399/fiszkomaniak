import 'package:flutter/material.dart';

class StudyGroupItemInfo extends StatelessWidget {
  final String courseName;
  final String groupName;

  const StudyGroupItemInfo({
    Key? key,
    required this.courseName,
    required this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(courseName, style: Theme.of(context).textTheme.caption),
        const SizedBox(height: 4),
        Text(groupName, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
