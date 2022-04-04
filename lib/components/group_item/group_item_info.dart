import 'package:flutter/material.dart';

class GroupItemInfo extends StatelessWidget {
  final String? courseName;
  final String groupName;

  const GroupItemInfo({
    Key? key,
    required this.courseName,
    required this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        courseName != null
            ? Text(
                courseName ?? '',
                style: Theme.of(context).textTheme.caption,
              )
            : const SizedBox(),
        SizedBox(height: courseName != null ? 4 : 0),
        Text(groupName, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
