import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/section.dart';
import '../../../ui_extensions/ui_duration_extensions.dart';
import '../../../ui_extensions/ui_time_extensions.dart';
import '../../../components/time_picker.dart';
import '../../../models/time_model.dart';
import '../bloc/session_creator_bloc.dart';
import 'session_creator_date_picker.dart';

class SessionCreatorDateAndTime extends StatelessWidget {
  const SessionCreatorDateAndTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Data i czas',
      child: Column(
        children: const [
          SessionCreatorDatePicker(),
          _StartTime(),
          _DurationTime(),
          _NotificationTime(),
        ],
      ),
    );
  }
}

class _StartTime extends StatelessWidget {
  const _StartTime();

  @override
  Widget build(BuildContext context) {
    final Time? startTime = context.select(
      (SessionCreatorBloc bloc) => bloc.state.startTime,
    );
    return TimePicker(
      icon: MdiIcons.clockStart,
      label: 'Godzina rozpoczęcia',
      value: startTime.toUIFormat(),
      initialTime: startTime,
      paddingLeft: 8.0,
      paddingRight: 8.0,
      helpText: 'WYBIERZ GODZINĘ ROZPOCZĘCIA',
      onSelect: (Time time) => _onSelected(time, context),
    );
  }

  void _onSelected(Time time, BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventStartTimeSelected(startTime: time));
  }
}

class _DurationTime extends StatelessWidget {
  const _DurationTime();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (SessionCreatorBloc bloc) => bloc.state.duration,
    );
    return Stack(
      children: [
        TimePicker(
          icon: MdiIcons.clockOutline,
          label: 'Czas trwania (opcjonalnie)',
          value: duration.toUIFormat(),
          initialTime: Time(
            hour: duration?.inHours ?? 0,
            minute: duration?.inMinutes.remainder(60) ?? 0,
          ),
          paddingLeft: 8.0,
          paddingRight: 8.0,
          helpText: 'WYBIERZ CZAS TRWANIA',
          onSelect: (Time duration) => _onDurationSelected(duration, context),
        ),
        duration != null
            ? Positioned(
                right: 0.0,
                bottom: 2.0,
                child: CustomIconButton(
                  icon: MdiIcons.close,
                  onPressed: () => _onResetButtonPressed(context),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  void _onDurationSelected(Time duration, BuildContext context) {
    if (duration.hour != 0 || duration.minute != 0) {
      context
          .read<SessionCreatorBloc>()
          .add(SessionCreatorEventDurationSelected(
            duration: Duration(hours: duration.hour, minutes: duration.minute),
          ));
    }
  }

  void _onResetButtonPressed(BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventCleanDurationTime());
  }
}

class _NotificationTime extends StatelessWidget {
  const _NotificationTime();

  @override
  Widget build(BuildContext context) {
    final Time? notificationTime = context.select(
      (SessionCreatorBloc bloc) => bloc.state.notificationTime,
    );
    return Stack(
      children: [
        TimePicker(
          icon: MdiIcons.bellRingOutline,
          label: 'Godzina powiadomienia (opcjonalnie)',
          value: notificationTime.toUIFormat(),
          initialTime: notificationTime,
          paddingLeft: 8.0,
          paddingRight: 8.0,
          helpText: 'WYBIERZ GODZINĘ PRZYPOMNIENIA',
          onSelect: (Time notificationTime) =>
              _onNotificationTimeSelected(notificationTime, context),
        ),
        notificationTime != null
            ? Positioned(
                right: 0.0,
                bottom: 2.0,
                child: CustomIconButton(
                  icon: MdiIcons.close,
                  onPressed: () => _onResetButtonPressed(context),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  void _onNotificationTimeSelected(
    Time notificationTime,
    BuildContext context,
  ) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventNotificationTimeSelected(
          notificationTime: notificationTime,
        ));
  }

  void _onResetButtonPressed(BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventCleanNotificationTime());
  }
}
