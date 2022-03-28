import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/features/study/components/study_group_item_info.dart';
import 'package:flutter/material.dart';

class StudyGroupItem extends StatelessWidget {
  final String courseName;
  final String groupName;
  final int amountOfLearnedFlashcards;
  final int amountOfAllFlashcards;
  final VoidCallback? onTap;

  const StudyGroupItem({
    Key? key,
    required this.courseName,
    required this.groupName,
    required this.amountOfLearnedFlashcards,
    required this.amountOfAllFlashcards,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StudyGroupItemInfo(
                  courseName: courseName,
                  groupName: groupName,
                ),
                const SizedBox(height: 8),
                FlashcardsProgressBar(
                  amountOfLearnedFlashcards: amountOfLearnedFlashcards,
                  amountOfAllFlashcards: amountOfAllFlashcards,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
