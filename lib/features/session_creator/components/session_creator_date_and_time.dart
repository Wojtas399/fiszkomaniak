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
                onSelect: (TimeOfDay time) {
                  context
                      .read<SessionCreatorBloc>()
                      .add(SessionCreatorEventTimeSelected(time: time));
                },
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
                    onSelect: (TimeOfDay time) {
                      context.read<SessionCreatorBloc>().add(
                          SessionCreatorEventDurationSelected(duration: time));
                    },
                  ),
                  state.duration != null
                      ? Positioned(
                          right: 0.0,
                          bottom: 2.0,
                          child: CustomIconButton(
                            icon: MdiIcons.close,
                            onPressed: () {
                              context
                                  .read<SessionCreatorBloc>()
                                  .add(SessionCreatorEventCleanDurationTime());
                            },
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
                    initialTime: const TimeOfDay(hour: 0, minute: 0),
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                    helpText: 'WYBIERZ GODZINĘ PRZYPOMNIENIA',
                    onSelect: (TimeOfDay time) {
                      context
                          .read<SessionCreatorBloc>()
                          .add(SessionCreatorEventNotificationTimeSelected(
                            notificationTime: time,
                          ));
                    },
                  ),
                  state.notificationTime != null
                      ? Positioned(
                          right: 0.0,
                          bottom: 2.0,
                          child: CustomIconButton(
                            icon: MdiIcons.close,
                            onPressed: () {
                              context.read<SessionCreatorBloc>().add(
                                  SessionCreatorEventCleanNotificationTime());
                            },
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
}
