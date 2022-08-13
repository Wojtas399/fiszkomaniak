import 'package:flutter/material.dart';
import '../card_item.dart';
import '../flashcards_progress_bar.dart';
import 'group_item_info.dart';


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
          GroupItemInfo(
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
