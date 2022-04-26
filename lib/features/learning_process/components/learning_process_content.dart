import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_buttons.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_flashcards.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_header.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LearningProcessContent extends StatelessWidget {
  const LearningProcessContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningProcessBloc, LearningProcessState>(
      builder: (BuildContext context, LearningProcessState state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LearningProcessHeader(),
                SizedBox(height: 24.0),
                LearningProcessFlashcards(),
                SizedBox(height: 24.0),
                LearningProcessProgressBar(),
                SizedBox(height: 24.0),
                LearningProcessButtons(),
              ],
            ),
          ),
        );
      },
    );
  }
}
