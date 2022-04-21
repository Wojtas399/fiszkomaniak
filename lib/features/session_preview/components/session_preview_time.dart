import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/time_picker.dart';
import 'package:fiszkomaniak/converters/time_converter.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SessionPreviewTime extends StatelessWidget {
  const SessionPreviewTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionPreviewBloc, SessionPreviewState>(
      builder: (BuildContext context, SessionPreviewState state) {
        return Column(
          children: [
            state.mode == SessionMode.quick
                ? const SizedBox()
                : TimePicker(
                    icon: MdiIcons.clockStart,
                    label: 'Godzina rozpoczęcia',
                    value: convertTimeToViewFormat(state.time),
                    initialTime: state.time,
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                    onSelect: state.isOverdueSession
                        ? null
                        : (TimeOfDay value) => _timeChanged(context, value),
                  ),
            Stack(
              children: [
                TimePicker(
                  icon: MdiIcons.clockOutline,
                  label: 'Czas trwania',
                  value: convertTimeToDurationViewFormat(state.duration),
                  initialTime: state.duration,
                  paddingLeft: 8.0,
                  paddingRight: 8.0,
                  onSelect: (TimeOfDay value) => _durationChanged(
                    context,
                    value,
                  ),
                ),
                state.duration != null
                    ? Positioned(
                        right: 0.0,
                        bottom: 8.0,
                        child: CustomIconButton(
                          icon: MdiIcons.close,
                          onPressed: () => _cleanDuration(context),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            state.mode == SessionMode.quick
                ? const SizedBox()
                : Stack(
                    children: [
                      TimePicker(
                        icon: MdiIcons.bellRingOutline,
                        label: 'Godzina przypomnienia',
                        value: convertTimeToViewFormat(state.notificationTime),
                        initialTime: state.notificationTime,
                        paddingLeft: 8.0,
                        paddingRight: 8.0,
                        onSelect: state.isOverdueSession
                            ? null
                            : (TimeOfDay value) => _notificationTimeChanged(
                                  context,
                                  value,
                                ),
                      ),
                      state.notificationTime != null && !state.isOverdueSession
                          ? Positioned(
                              right: 0.0,
                              bottom: 8.0,
                              child: CustomIconButton(
                                icon: MdiIcons.close,
                                onPressed: () =>
                                    _cleanNotificationTime(context),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
          ],
        );
      },
    );
  }

  void _timeChanged(BuildContext context, TimeOfDay value) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventTimeChanged(time: value));
  }

  void _durationChanged(BuildContext context, TimeOfDay value) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventDurationChanged(duration: value));
  }

  void _cleanDuration(BuildContext context) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventDurationChanged(duration: null));
  }

  void _notificationTimeChanged(BuildContext context, TimeOfDay value) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventNotificationTimeChanged(
          notificationTime: value,
        ));
  }

  void _cleanNotificationTime(BuildContext context) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventNotificationTimeChanged(
          notificationTime: null,
        ));
  }
}
