import 'package:fiszkomaniak/converters/flashcards_type_converters.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/group_model.dart';
import '../bloc/learning_process_state.dart';

class LearningProcessHeader extends StatelessWidget {
  const LearningProcessHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningProcessBloc, LearningProcessState>(
      builder: (_, LearningProcessState state) {
        final Group? group = state.group;
        if (group == null) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Język angielski',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 8.0),
              Text(
                group.name,
                style: Theme.of(context).textTheme.headline6,
                maxLines: 2,
              ),
              const SizedBox(height: 4.0),
              Text(
                convertFlashcardsTypeToViewFormat(state.flashcardsType),
                style: TextStyle(color: Colors.black.withOpacity(0.60)),
              ),
            ],
          ),
        );
      },
    );
  }
}
