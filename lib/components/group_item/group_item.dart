import 'package:fiszkomaniak/components/card_item.dart';
import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/components/group_item/group_item_info.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  final String? courseName;
  final String groupName;
  final int amountOfRememberedFlashcards;
  final int amountOfAllFlashcards;
  final VoidCallback? onTap;

  const GroupItem({
    Key? key,
    this.courseName,
    required this.groupName,
    required this.amountOfRememberedFlashcards,
    required this.amountOfAllFlashcards,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardItem(
      onTap: onTap,
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
