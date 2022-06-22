import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/components/card_item.dart';
import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/components/group_item/group_item_info.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  final GroupItemParams params;

  const GroupItem({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return CardItem(
      onTap: params.onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupItemInfo(
            courseName: params.courseName,
            groupName: params.name,
          ),
          const SizedBox(height: 8),
          FlashcardsProgressBar(
            amountOfRememberedFlashcards: params.amountOfRememberedFlashcards,
            amountOfAllFlashcards: params.amountOfAllFlashcards,
          ),
        ],
      ),
    );
  }
}

class GroupItemParams extends Equatable {
  final String name;
  final String? courseName;
  final int amountOfRememberedFlashcards;
  final int amountOfAllFlashcards;
  final VoidCallback? onPressed;

  const GroupItemParams({
    required this.name,
    required this.courseName,
    required this.amountOfRememberedFlashcards,
    required this.amountOfAllFlashcards,
    required this.onPressed,
  });

  @override
  List<Object> get props => [
        name,
        courseName ?? '',
        amountOfRememberedFlashcards,
        amountOfAllFlashcards,
      ];
}

GroupItemParams createGroupItemParams({
  String? name,
  String? courseName,
  int? amountOfRememberedFlashcards,
  int? amountOfAllFlashcards,
  VoidCallback? onPressed,
}) {
  return GroupItemParams(
    name: name ?? '',
    courseName: courseName,
    amountOfRememberedFlashcards: amountOfRememberedFlashcards ?? 0,
    amountOfAllFlashcards: amountOfAllFlashcards ?? 0,
    onPressed: onPressed ?? () {},
  );
}
