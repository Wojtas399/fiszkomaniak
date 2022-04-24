import 'package:fiszkomaniak/components/card_item.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/converters/date_converters.dart';
import 'package:fiszkomaniak/converters/time_converters.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionItem extends StatelessWidget {
  final Session session;
  final String groupName;
  final String courseName;

  const SessionItem({
    Key? key,
    required this.session,
    required this.groupName,
    required this.courseName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: CardItem(
        onTap: () {
          context.read<Navigation>().navigateToSessionPreview(
                SessionPreviewModeNormal(sessionId: session.id),
              );
        },
        child: Row(
          children: [
            _BigDate(date: session.date),
            const VerticalDivider(thickness: 1),
            Expanded(
              child: Column(
                children: [
                  _Title(courseName: courseName, groupName: groupName),
                  const SizedBox(height: 8),
                  _TimeAndDuration(
                    time: session.time,
                    duration: session.duration,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigDate extends StatelessWidget {
  final DateTime date;

  const _BigDate({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String monthAsString = convertNumberToDateStr(date.month);
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

  const _Title({
    Key? key,
    required this.courseName,
    required this.groupName,
  }) : super(key: key);

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
  final TimeOfDay time;
  final TimeOfDay? duration;

  const _TimeAndDuration({
    Key? key,
    required this.time,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String timeAsString = convertTimeToViewFormat(time);
    final String durationAsString = convertTimeToDurationViewFormat(duration);
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Godzina', style: Theme.of(context).textTheme.caption),
                const SizedBox(height: 4),
                Text(timeAsString),
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
                Text(durationAsString),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
