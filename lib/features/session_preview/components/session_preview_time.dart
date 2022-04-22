import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/item_with_icon.dart';
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
                : ItemWithIcon(
                    icon: MdiIcons.clockStart,
                    label: 'Godzina rozpoczęcia',
                    text: convertTimeToViewFormat(state.session?.time),
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
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
                  onSelect: state.mode == SessionMode.quick
                      ? (TimeOfDay value) => _durationChanged(
                            context,
                            value,
                          )
                      : null,
                ),
                state.mode == SessionMode.quick && state.duration != null
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
                : ItemWithIcon(
                    icon: MdiIcons.bellRingOutline,
                    label: 'Godzina przypomnienia',
                    text: convertTimeToViewFormat(
                      state.session?.notificationTime,
                    ),
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                  ),
          ],
        );
      },
    );
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
}
