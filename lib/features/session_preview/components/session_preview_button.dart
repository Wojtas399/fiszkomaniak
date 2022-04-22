import 'package:fiszkomaniak/components/button.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionPreviewButton extends StatelessWidget {
  const SessionPreviewButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionPreviewBloc, SessionPreviewState>(
      builder: (BuildContext context, SessionPreviewState state) {
        return Positioned(
          bottom: 24.0,
          left: 24.0,
          right: 24.0,
          child: Button(
            label: 'rozpocznij naukę',
            onPressed: () {},
          ),
        );
      },
    );
  }
}
