import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Session extends Equatable {
  final String groupId;
  final FlashcardsType flashcardsType;
  final DateTime date;
  final TimeOfDay time;
  final TimeOfDay duration;
  final TimeOfDay notificationTime;

  const Session({
    required this.groupId,
    required this.flashcardsType,
    required this.date,
    required this.time,
    required this.duration,
    required this.notificationTime,
  });

  @override
  List<Object> get props => [
        groupId,
        flashcardsType,
        date,
        time,
        duration,
        notificationTime,
      ];
}

enum FlashcardsType {
  all,
  remembered,
  notRemembered,
}
