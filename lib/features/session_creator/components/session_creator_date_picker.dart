import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/ui_extensions/ui_date_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../models/date_model.dart';

class SessionCreatorDatePicker extends StatefulWidget {
  const SessionCreatorDatePicker({super.key});

  @override
  State<SessionCreatorDatePicker> createState() =>
      _SessionCreatorDatePickerState();
}

class _SessionCreatorDatePickerState extends State<SessionCreatorDatePicker> {
  @override
  Widget build(BuildContext context) {
    final Date? date = context.select(
      (SessionCreatorBloc bloc) => bloc.state.date,
    );
    return ItemWithIcon(
      icon: MdiIcons.calendarOutline,
      label: 'Data',
      text: date.toUIFormat(),
      paddingLeft: 8.0,
      paddingRight: 8.0,
      onTap: () async => await _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      confirmText: 'WYBIERZ',
      cancelText: 'ANULUJ',
      initialDate: DateTime.now(),
      lastDate: DateUtils.addDaysToDate(DateTime.now(), 3650),
      firstDate: DateTime.now(),
      locale: const Locale('pl', 'PL'),
    );
    if (date != null && mounted) {
      _onDateSelected(
        context,
        Date(year: date.year, month: date.month, day: date.day),
      );
    }
  }

  void _onDateSelected(BuildContext context, Date date) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventDateSelected(date: date));
  }
}
