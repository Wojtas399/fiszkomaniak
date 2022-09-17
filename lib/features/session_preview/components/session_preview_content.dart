import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/buttons/button.dart';
import '../../../config/navigation.dart';
import '../../learning_process/learning_process_arguments.dart';
import '../bloc/session_preview_bloc.dart';
import 'session_preview_app_bar.dart';
import 'session_preview_flashcards.dart';
import 'session_preview_time.dart';
import 'session_preview_title.dart';

class SessionPreviewContent extends StatelessWidget {
  const SessionPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SessionPreviewAppBar(),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 24.0,
                    bottom: 96.0,
                  ),
                  child: Column(
                    children: const [
                      SessionPreviewTitle(),
                      SizedBox(height: 8.0),
                      SessionPreviewTime(),
                      SessionPreviewFlashcards(),
                    ],
                  ),
                ),
              ),
              const _StartLearningButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartLearningButton extends StatelessWidget {
  const _StartLearningButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24.0,
      left: 24.0,
      right: 24.0,
      child: Button(
        label: 'rozpocznij naukę',
        onPressed: () => _startLearning(context),
      ),
    );
  }

  void _startLearning(BuildContext context) {
    final SessionPreviewState state = context.read<SessionPreviewBloc>().state;
    final String? groupId = state.group?.id;
    if (groupId != null) {
      Navigation.navigateToLearningProcess(
        LearningProcessArguments(
          sessionId: state.session?.id,
          groupId: groupId,
          flashcardsType: state.flashcardsType,
          areQuestionsAndAnswersSwapped: state.areQuestionsAndAnswersSwapped,
          duration: state.duration,
        ),
      );
    }
  }
}
