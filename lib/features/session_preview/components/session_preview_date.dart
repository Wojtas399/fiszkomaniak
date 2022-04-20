import 'package:fiszkomaniak/converters/date_converters.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionPreviewDate extends StatelessWidget {
  const SessionPreviewDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionPreviewBloc, SessionPreviewState>(
      builder: (BuildContext context, SessionPreviewState state) {
        final String dateAsString = convertDateToViewFormatWithDayAndMonthNames(
          state.session?.date,
        );
        return SizedBox(
          width: double.infinity,
          child: Text(
            dateAsString,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }
}
