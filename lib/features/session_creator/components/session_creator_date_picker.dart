import 'package:fiszkomaniak/converters/date_converter.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';

class SessionCreatorDatePicker extends StatelessWidget {
  const SessionCreatorDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCreatorBloc, SessionCreatorState>(
      builder: (BuildContext context, SessionCreatorState state) {
        final DateTime? date = state.date;
        return ItemWithIcon(
          icon: MdiIcons.calendarOutline,
          label: 'Data',
          text: convertDateToViewFormat(date),
          paddingLeft: 8.0,
          paddingRight: 8.0,
          onTap: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              confirmText: 'WYBIERZ',
              cancelText: 'ANULUJ',
              initialDate: DateTime.now(),
              lastDate: DateUtils.addDaysToDate(DateTime.now(), 3650),
              firstDate: DateTime.now(),
              locale: const Locale('pl', 'PL'),
            );
            if (date != null) {
              context
                  .read<SessionCreatorBloc>()
                  .add(SessionCreatorEventDateSelected(date: date));
            }
          },
        );
      },
    );
  }
}