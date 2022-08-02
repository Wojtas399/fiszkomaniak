import 'package:fiszkomaniak/features/session_creator/components/session_creator_app_bar.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_date_and_time.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_flashcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/buttons/button.dart';
import '../bloc/session_creator_bloc.dart';
import '../bloc/session_creator_mode.dart';

class SessionCreatorContent extends StatelessWidget {
  const SessionCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SessionCreatorAppBar(),
      body: BouncingScroll(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: const [
                SessionCreatorFlashcards(),
                SessionCreatorDateAndTime(),
                SizedBox(height: 16),
                _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final SessionCreatorMode mode = context.select(
      (SessionCreatorBloc bloc) => bloc.state.mode,
    );
    final bool isDisabled = context.select(
      (SessionCreatorBloc bloc) => bloc.state.isButtonDisabled,
    );
    return Button(
      label: _getLabel(mode),
      onPressed: isDisabled ? null : () => _onPressed(context),
    );
  }

  String _getLabel(SessionCreatorMode mode) {
    if (mode is SessionCreatorCreateMode) {
      return 'dodaj';
    } else if (mode is SessionCreatorEditMode) {
      return 'zapisz';
    }
    return '';
  }

  void _onPressed(BuildContext context) {
    context.read<SessionCreatorBloc>().add(SessionCreatorEventSubmit());
  }
}
