import 'package:flutter/material.dart';

class CourseItemInfo extends StatelessWidget {
  final String title;
  final int amountOfGroups;

  const CourseItemInfo({
    super.key,
    required this.title,
    required this.amountOfGroups,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 4),
          Text(
            'Liczba grup: $amountOfGroups',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
