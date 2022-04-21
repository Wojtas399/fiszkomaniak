import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../converters/date_converters.dart';

class SessionPreviewTitle extends StatelessWidget {
  const SessionPreviewTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionPreviewBloc, SessionPreviewState>(
      builder: (BuildContext context, SessionPreviewState state) {
        final String dateAsString = convertDateToViewFormatWithDayAndMonthNames(
          state.session?.date,
        );
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateAsString,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16.0),
              Text(
                state.group?.name ?? '--',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 4.0),
              Text(
                state.courseName ?? '--',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        );
      },
    );
  }
}
