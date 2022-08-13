import 'package:flutter/material.dart';
import '../../components/card_item.dart';
import '../../config/navigation.dart';
import '../../models/date_model.dart';
import '../../models/time_model.dart';
import '../../utils/utils.dart';
import '../../ui_extensions/ui_duration_extensions.dart';
import '../../ui_extensions/ui_time_extensions.dart';
import '../session_preview/bloc/session_preview_mode.dart';

class SessionsListItem extends StatelessWidget {
  final String sessionId;
  final Date date;
  final Time startTime;
  final Duration? duration;
  final String groupName;
  final String courseName;

  const SessionsListItem({
    super.key,
    required this.sessionId,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.groupName,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: CardItem(
        onTap: () => _onPressed(context),
        child: Row(
          children: [
            _BigDate(date: date),
            const VerticalDivider(thickness: 1),
            Expanded(
              child: Column(
                children: [
                  _Title(
                    courseName: courseName,
                    groupName: groupName,
                  ),
                  const SizedBox(height: 8),
                  _TimeAndDuration(
                    time: startTime,
                    duration: duration,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    Navigation.navigateToSessionPreview(
      SessionPreviewModeNormal(sessionId: sessionId),
    );
  }
}

class _BigDate extends StatelessWidget {
  final Date date;

  const _BigDate({required this.date});

  @override
  Widget build(BuildContext context) {
    final String monthAsString = Utils.twoDigits(date.month);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${date.day}', style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 4),
        Text(
          '$monthAsString.${date.year}',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String courseName;
  final String groupName;

  const _Title({required this.courseName, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(courseName, style: Theme.of(context).textTheme.caption),
          const SizedBox(height: 4),
          Text(groupName, style: Theme.of(context).textTheme.subtitle1)
        ],
      ),
    );
  }
}

class _TimeAndDuration extends StatelessWidget {
  final Time time;
  final Duration? duration;

  const _TimeAndDuration({required this.time, required this.duration});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Godzina', style: Theme.of(context).textTheme.caption),
                const SizedBox(height: 4),
                Text(time.toUIFormat()),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Czas trwania',
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: 4),
                Text(duration.toUIFormat()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
