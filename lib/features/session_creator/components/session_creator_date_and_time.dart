import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/time_picker.dart';
import '../../../converters/time_converter.dart';
import '../bloc/session_creator_event.dart';

class SessionCreatorDateAndTime extends StatelessWidget {
  const SessionCreatorDateAndTime({Key? key}) : super(key: key);

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
                value: convertTimeToViewFormat(state.time),
                paddingLeft: 8.0,
                paddingRight: 8.0,
                helpText: 'WYBIERZ GODZINĘ ROZPOCZĘCIA',
                onSelect: (TimeOfDay time) => _timeSelected(context, time),
              ),
              Stack(
                children: [
                  TimePicker(
                    icon: MdiIcons.clockOutline,
                    label: 'Czas trwania (opcjonalnie)',
                    value: convertTimeToDurationViewFormat(state.duration),
                    initialTime:
                        state.duration ?? const TimeOfDay(hour: 0, minute: 0),
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                    helpText: 'WYBIERZ CZAS TRWANIA',
                    onSelect: (TimeOfDay duration) => _durationSelected(
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
                    label: 'Godzina przypomnienia (opcjonalnie)',
                    value: convertTimeToViewFormat(state.notificationTime),
                    initialTime: state.notificationTime ??
                        const TimeOfDay(hour: 0, minute: 0),
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                    helpText: 'WYBIERZ GODZINĘ PRZYPOMNIENIA',
                    onSelect: (TimeOfDay notificationTime) =>
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

  void _timeSelected(BuildContext context, TimeOfDay time) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventTimeSelected(time: time));
  }

  void _durationSelected(BuildContext context, TimeOfDay duration) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventDurationSelected(duration: duration));
  }

  void _cleanDuration(BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventCleanDurationTime());
  }

  void _notificationTimeSelected(
    BuildContext context,
    TimeOfDay notificationTime,
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
