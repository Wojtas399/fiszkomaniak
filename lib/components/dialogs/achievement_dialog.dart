import 'package:flutter/material.dart';

class AchievementDialog extends StatelessWidget {
  final int achievementValue;
  final String title;
  final String? textBeforeAchievementValue;
  final String? textAfterAchievementValue;

  const AchievementDialog({
    super.key,
    required this.achievementValue,
    required this.title,
    this.textBeforeAchievementValue,
    this.textAfterAchievementValue,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(textBeforeAchievementValue ?? ''),
          SizedBox(height: textBeforeAchievementValue != null ? 16.0 : 0.0),
          Text(
            '$achievementValue',
            style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16.0),
          Text(textAfterAchievementValue ?? ''),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Zamknij'),
        ),
      ],
    );
  }
}
