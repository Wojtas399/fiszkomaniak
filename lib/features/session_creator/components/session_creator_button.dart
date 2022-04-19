import 'package:fiszkomaniak/components/button.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCreatorButton extends StatelessWidget {
  const SessionCreatorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCreatorBloc, SessionCreatorState>(
      builder: (BuildContext context, SessionCreatorState state) {
        return Button(
          label: 'dodaj',
          onPressed: state.isButtonDisabled
              ? null
              : () {
                  context
                      .read<SessionCreatorBloc>()
                      .add(SessionCreatorEventSubmit());
                },
        );
      },
    );
  }
}
