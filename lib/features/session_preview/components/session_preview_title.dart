import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/date_model.dart';
import '../../../ui_extensions/ui_date_extensions.dart';
import '../bloc/session_preview_bloc.dart';

class SessionPreviewTitle extends StatelessWidget {
  const SessionPreviewTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Date(),
          SizedBox(height: 16.0),
          _GroupName(),
          SizedBox(height: 4.0),
          _CourseName(),
        ],
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final Date? date = context.select(
      (SessionPreviewBloc bloc) => bloc.state.date,
    );
    return Text(
      date.toUIFormatWithDayAndMonthNames(),
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class _GroupName extends StatelessWidget {
  const _GroupName();

  @override
  Widget build(BuildContext context) {
    final String? groupName = context.select(
      (SessionPreviewBloc bloc) => bloc.state.group?.name,
    );
    return Text(
      groupName ?? '--',
      style: Theme.of(context).textTheme.headline5,
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName();

  @override
  Widget build(BuildContext context) {
    final String? courseName = context.select(
      (SessionPreviewBloc bloc) => bloc.state.courseName,
    );
    return Text(
      courseName ?? '--',
      style: Theme.of(context).textTheme.subtitle1,
    );
  }
}
