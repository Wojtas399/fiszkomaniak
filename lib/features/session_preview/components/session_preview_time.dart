import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/components/time_picker.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/ui_extensions/ui_duration_extensions.dart';
import 'package:fiszkomaniak/ui_extensions/ui_time_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../models/time_model.dart';

class SessionPreviewTime extends StatelessWidget {
  const SessionPreviewTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _StartTime(),
        _Duration(),
        _NotificationTime(),
      ],
    );
  }
}

class _StartTime extends StatelessWidget {
  const _StartTime();

  @override
  Widget build(BuildContext context) {
    final SessionPreviewMode? mode = context.select(
      (SessionPreviewBloc bloc) => bloc.state.mode,
    );
    final Time? startTime = context.select(
      (SessionPreviewBloc bloc) => bloc.state.session?.startTime,
    );
    return mode is SessionPreviewModeQuick
        ? const SizedBox()
        : ItemWithIcon(
            icon: MdiIcons.clockStart,
            label: 'Godzina rozpoczęcia',
            text: startTime.toUIFormat(),
            paddingLeft: 8.0,
            paddingRight: 8.0,
          );
  }
}

class _Duration extends StatelessWidget {
  const _Duration();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (SessionPreviewBloc bloc) => bloc.state.duration,
    );
    final SessionPreviewMode? mode = context.select(
      (SessionPreviewBloc bloc) => bloc.state.mode,
    );
    return Stack(
      children: [
        TimePicker(
          icon: MdiIcons.clockOutline,
          label: 'Czas trwania',
          helpText: 'WYBIERZ CZAS TRWANIA',
          value: duration.toUIFormat(),
          initialTime: Time(
            hour: duration?.inHours ?? 0,
            minute: duration?.inMinutes.remainder(60) ?? 0,
          ),
          paddingLeft: 8.0,
          paddingRight: 8.0,
          onSelect: mode is SessionPreviewModeQuick
              ? (Time value) => _durationChanged(context, value)
              : null,
        ),
        mode is SessionPreviewModeQuick && duration != null
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
    );
  }

  void _durationChanged(BuildContext context, Time value) {
    context.read<SessionPreviewBloc>().add(
          SessionPreviewEventDurationChanged(
            duration: Duration(hours: value.hour, minutes: value.minute),
          ),
        );
  }

  void _cleanDuration(BuildContext context) {
    context.read<SessionPreviewBloc>().add(SessionPreviewEventResetDuration());
  }
}

class _NotificationTime extends StatelessWidget {
  const _NotificationTime();

  @override
  Widget build(BuildContext context) {
    final SessionPreviewMode? mode = context.select(
      (SessionPreviewBloc bloc) => bloc.state.mode,
    );
    final Time? notificationTime = context.select(
      (SessionPreviewBloc bloc) => bloc.state.session?.notificationTime,
    );
    return mode is SessionPreviewModeQuick
        ? const SizedBox()
        : ItemWithIcon(
            icon: MdiIcons.bellRingOutline,
            label: 'Godzina przypomnienia',
            text: notificationTime.toUIFormat(),
            paddingLeft: 8.0,
            paddingRight: 8.0,
          );
  }
}
