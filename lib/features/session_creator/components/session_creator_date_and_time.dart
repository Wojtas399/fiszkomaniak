import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_date_picker.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_duration_picker.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_notification_picker.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_time_picker.dart';
import 'package:flutter/material.dart';

class SessionCreatorDateAndTime extends StatelessWidget {
  const SessionCreatorDateAndTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Data i czas',
      child: Column(
        children: const [
          SessionCreatorDatePicker(),
          SessionCreatorTimePicker(),
          SessionCreatorDurationPicker(),
          SessionCreatorNotificationPicker(),
        ],
      ),
    );
  }
}
