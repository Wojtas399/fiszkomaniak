import 'package:fiszkomaniak/components/card_item.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/features/sessions_list/bloc/sessions_list_bloc.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/ui_extensions/ui_duration_extensions.dart';
import 'package:fiszkomaniak/ui_extensions/ui_time_extensions.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/date_model.dart';

class SessionsListItem extends StatelessWidget {
  final SessionItemParams params;

  const SessionsListItem({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: CardItem(
        onTap: () => _onPressed(context),
        child: Row(
          children: [
            _BigDate(date: params.date),
            const VerticalDivider(thickness: 1),
            Expanded(
              child: Column(
                children: [
                  _Title(
                    courseName: params.courseName,
                    groupName: params.groupName,
                  ),
                  const SizedBox(height: 8),
                  _TimeAndDuration(
                    time: params.startTime,
                    duration: params.duration,
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
    context.read<Navigation>().navigateToSessionPreview(
          SessionPreviewModeNormal(sessionId: params.sessionId),
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
