import 'package:flutter/material.dart';
import 'card_item.dart';
import 'flashcards_progress_bar.dart';

class GroupItem extends StatelessWidget {
  final String groupName;
  final String? courseName;
  final int amountOfRememberedFlashcards;
  final int amountOfAllFlashcards;
  final VoidCallback? onPressed;

  const GroupItem({
    super.key,
    required this.groupName,
    required this.courseName,
    required this.amountOfRememberedFlashcards,
    required this.amountOfAllFlashcards,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CardItem(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Info(
            courseName: courseName,
            groupName: groupName,
          ),
          const SizedBox(height: 8),
          FlashcardsProgressBar(
            amountOfRememberedFlashcards: amountOfRememberedFlashcards,
            amountOfAllFlashcards: amountOfAllFlashcards,
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String? courseName;
  final String groupName;

  const _Info({
    required this.courseName,
    required this.groupName,
  });

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
