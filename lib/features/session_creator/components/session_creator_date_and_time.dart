import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_date_picker.dart';
import 'package:fiszkomaniak/ui_extensions/ui_duration_extensions.dart';
import 'package:fiszkomaniak/ui_extensions/ui_time_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/time_picker.dart';
import '../../../models/time_model.dart';

class SessionCreatorDateAndTime extends StatelessWidget {
  const SessionCreatorDateAndTime({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCreatorBloc, SessionCreatorState>(
      builder: (BuildContext context, SessionCreatorState state) {
        return Section(
          title: 'Data i czas',
          child: Column(
            children: [
              const SessionCreatorDatePicker(),
              TimePicker(
                icon: MdiIcons.clockStart,
                label: 'Godzina rozpoczęcia',
                value: state.time.toUIFormat(),
                initialTime: state.time,
                paddingLeft: 8.0,
                paddingRight: 8.0,
                helpText: 'WYBIERZ GODZINĘ ROZPOCZĘCIA',
                onSelect: (Time time) => _timeSelected(context, time),
              ),
              Stack(
                children: [
                  TimePicker(
                    icon: MdiIcons.clockOutline,
                    label: 'Czas trwania (opcjonalnie)',
                    value: state.duration.toUIFormat(),
                    initialTime: Time(
                      hour: state.duration?.inHours ?? 0,
                      minute: state.duration?.inMinutes.remainder(60) ?? 0,
                    ),
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                    helpText: 'WYBIERZ CZAS TRWANIA',
                    onSelect: (Time duration) => _durationSelected(
                      context,
                      duration,
                    ),
                  ),
                  state.duration != null
                      ? Positioned(
                          right: 0.0,
                          bottom: 2.0,
                          child: CustomIconButton(
                            icon: MdiIcons.close,
                            onPressed: () => _cleanDuration(context),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              Stack(
                children: [
                  TimePicker(
                    icon: MdiIcons.bellRingOutline,
                    label: 'Godzina powiadomienia (opcjonalnie)',
                    value: state.notificationTime.toUIFormat(),
                    initialTime: state.notificationTime,
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                    helpText: 'WYBIERZ GODZINĘ PRZYPOMNIENIA',
                    onSelect: (Time notificationTime) =>
                        _notificationTimeSelected(context, notificationTime),
                  ),
                  state.notificationTime != null
                      ? Positioned(
                          right: 0.0,
                          bottom: 2.0,
                          child: CustomIconButton(
                            icon: MdiIcons.close,
                            onPressed: () => _cleanNotificationTime(context),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _timeSelected(BuildContext context, Time time) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventTimeSelected(time: time));
  }

  void _durationSelected(BuildContext context, Time duration) {
    if (duration.hour != 0 || duration.minute != 0) {
      context
          .read<SessionCreatorBloc>()
          .add(SessionCreatorEventDurationSelected(
            duration: Duration(hours: duration.hour, minutes: duration.minute),
          ));
    }
  }

  void _cleanDuration(BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventCleanDurationTime());
  }

  void _notificationTimeSelected(
    BuildContext context,
    Time notificationTime,
  ) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventNotificationTimeSelected(
          notificationTime: notificationTime,
        ));
  }

  void _cleanNotificationTime(BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventCleanNotificationTime());
  }
}
